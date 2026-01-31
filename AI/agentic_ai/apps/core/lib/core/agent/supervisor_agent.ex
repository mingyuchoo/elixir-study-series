defmodule Core.Agent.SupervisorAgent do
  @moduledoc """
  Supervisor 에이전트 GenServer.

  사용자 요청을 분석하고 적절한 Worker에게 작업을 전달합니다.
  Worker의 결과를 수집하여 사용자에게 응답합니다.
  """

  use GenServer
  require Logger

  alias Core.Agent.{Coordinator, MemoryManager, TaskRouter, WorkerAgent}
  alias Core.Contexts.Agents
  alias Core.Schema.{Agent, Message}
  alias Core.Repo

  defstruct [:agent_id, :agent, :conversation_id, :worker_agents]

  # 클라이언트 API

  @doc """
  SupervisorAgent 프로세스를 시작합니다.

  ## Options

    - `:agent_id` - Supervisor 에이전트 ID (필수)
    - `:conversation_id` - 대화 ID (필수)
  """
  def start_link(opts) do
    agent_id = Keyword.fetch!(opts, :agent_id)
    conversation_id = Keyword.fetch!(opts, :conversation_id)

    GenServer.start_link(__MODULE__, {agent_id, conversation_id},
      name: via_tuple(conversation_id)
    )
  end

  @doc """
  Supervisor에게 사용자 메시지를 전달합니다.

  ## Parameters

    - `conversation_id` - 대화 ID
    - `user_message` - 사용자 메시지

  ## Returns

    - `{:ok, response}` - 성공 시 응답
    - `{:error, reason}` - 실패 시 오류 원인
  """
  def chat(conversation_id, user_message) do
    GenServer.call(via_tuple(conversation_id), {:chat, user_message}, 180_000)
  end

  # 서버 콜백

  @impl true
  def init({agent_id, conversation_id}) do
    case Agents.get_agent(agent_id) do
      nil ->
        {:stop, {:error, :agent_not_found}}

      %Agent{type: :supervisor} = agent ->
        # 사용 가능한 Worker 로드
        worker_agents_data = Agents.list_workers()

        # Worker 프로세스 시작
        worker_agents = start_workers(worker_agents_data)

        state = %__MODULE__{
          agent_id: agent_id,
          agent: agent,
          conversation_id: conversation_id,
          worker_agents: worker_agents
        }

        Logger.info("SupervisorAgent started: #{agent.name} for conversation #{conversation_id}")

        Logger.info(
          "Available workers: #{inspect(Enum.map(worker_agents, fn {a, _} -> a.name end))}"
        )

        {:ok, state}

      %Agent{type: type} ->
        {:stop, {:error, {:invalid_agent_type, type}}}
    end
  end

  @impl true
  def handle_call({:chat, user_message}, _from, state) do
    Logger.info("SupervisorAgent received message: #{user_message}")

    start_time = System.monotonic_time(:millisecond)

    # 사용자 메시지 저장
    save_message(state.conversation_id, %{
      role: :user,
      content: user_message,
      agent_id: nil
    })

    # Worker에게 작업 위임
    case delegate_to_worker(state, user_message) do
      {:ok, result, worker_name} ->
        duration_ms = System.monotonic_time(:millisecond) - start_time

        # 어시스턴트 메시지 저장
        save_message(state.conversation_id, %{
          role: :assistant,
          content: result,
          agent_id: state.agent_id
        })

        # 성능 메트릭 기록
        record_performance_metric(state, worker_name, duration_ms, true)

        {:reply, {:ok, result}, state}

      {:error, reason} = error ->
        duration_ms = System.monotonic_time(:millisecond) - start_time

        # 오류 메시지 저장
        error_message = "작업 수행 중 오류가 발생했습니다: #{inspect(reason)}"

        save_message(state.conversation_id, %{
          role: :assistant,
          content: error_message,
          agent_id: state.agent_id
        })

        # 실패 메트릭 기록
        record_performance_metric(state, "unknown", duration_ms, false)

        # 학습을 위한 오류 패턴 기록
        record_error_pattern(state, user_message, reason)

        {:reply, error, state}
    end
  end

  @impl true
  def terminate(reason, state) do
    Logger.info("SupervisorAgent terminating: #{inspect(reason)}")

    # 모든 Worker 프로세스 종료
    Enum.each(state.worker_agents, fn {_agent, pid} ->
      if Process.alive?(pid) do
        Process.exit(pid, :shutdown)
      end
    end)

    :ok
  end

  # 비공개 함수들

  defp via_tuple(conversation_id) do
    {:via, Registry, {Core.Agent.Registry, {:supervisor, conversation_id}}}
  end

  defp start_workers(worker_agents_data) do
    Enum.map(worker_agents_data, fn agent ->
      case WorkerAgent.start_link(agent_id: agent.id) do
        {:ok, pid} ->
          {agent, pid}

        {:error, reason} ->
          Logger.error("Failed to start worker #{agent.name}: #{inspect(reason)}")
          {agent, nil}
      end
    end)
    |> Enum.filter(fn {_agent, pid} -> pid != nil end)
  end

  defp delegate_to_worker(state, user_request) do
    # 3단계 파이프라인 실행:
    # 1단계: 핵심 Worker 선택 및 실행 (calculator, general 등)
    # 2단계: restructure_worker로 구조 재편
    # 3단계: emoji_worker로 스타일 개선

    # 후처리 Worker 제외한 핵심 Worker만 필터링
    postprocess_workers = ["restructure_worker", "emoji_worker"]

    available_workers =
      state.worker_agents
      |> Enum.map(fn {agent, _pid} -> agent end)
      |> Enum.reject(fn agent -> agent.name in postprocess_workers end)

    # 1단계: 핵심 Worker 선택 및 실행
    case TaskRouter.select_worker(user_request, available_workers) do
      {:ok, selected_worker} ->
        Logger.info("[Pipeline 1/3] Selected primary worker: #{selected_worker.name}")

        case execute_worker_by_agent(state, selected_worker, user_request, nil) do
          {:ok, primary_result} ->
            Logger.info("[Pipeline 1/3] Primary worker completed")

            # 2단계: restructure_worker로 구조 재편
            case execute_postprocess_worker(state, "restructure_worker", primary_result) do
              {:ok, restructured_result} ->
                Logger.info("[Pipeline 2/3] Restructure worker completed")

                # 3단계: emoji_worker로 스타일 개선
                case execute_postprocess_worker(state, "emoji_worker", restructured_result) do
                  {:ok, final_result} ->
                    Logger.info("[Pipeline 3/3] Emoji worker completed - Pipeline finished")
                    {:ok, final_result, selected_worker.name}

                  {:error, :worker_not_found} ->
                    Logger.warning(
                      "[Pipeline 3/3] emoji_worker not found, using restructured result"
                    )

                    {:ok, restructured_result, selected_worker.name}

                  {:error, reason} ->
                    Logger.warning(
                      "[Pipeline 3/3] emoji_worker failed: #{inspect(reason)}, using restructured result"
                    )

                    {:ok, restructured_result, selected_worker.name}
                end

              {:error, :worker_not_found} ->
                Logger.warning(
                  "[Pipeline 2/3] restructure_worker not found, using primary result"
                )

                {:ok, primary_result, selected_worker.name}

              {:error, reason} ->
                Logger.warning(
                  "[Pipeline 2/3] restructure_worker failed: #{inspect(reason)}, using primary result"
                )

                {:ok, primary_result, selected_worker.name}
            end

          {:error, reason} ->
            {:error, reason}
        end

      {:error, :no_workers_available} = error ->
        Logger.error("No workers available")
        error
    end
  end

  # 특정 Agent 구조체로 Worker 실행
  defp execute_worker_by_agent(state, agent, user_request, context) do
    case find_worker_pid(state, agent.id) do
      {:ok, worker_pid} ->
        task_attrs = %{
          conversation_id: state.conversation_id,
          supervisor_id: state.agent_id,
          user_request: user_request,
          context: context
        }

        Coordinator.send_task(state.agent_id, agent.id, worker_pid, task_attrs)

      {:error, _} = error ->
        error
    end
  end

  # 이름으로 후처리 Worker 실행 (이전 단계 결과를 context로 전달)
  defp execute_postprocess_worker(state, worker_name, previous_result) do
    case find_worker_by_name(state, worker_name) do
      {:ok, agent, worker_pid} ->
        # 후처리 Worker에게는 이전 결과를 user_request로 전달
        # (텍스트 변환이 주 목적이므로)
        task_attrs = %{
          conversation_id: state.conversation_id,
          supervisor_id: state.agent_id,
          user_request: previous_result,
          context: "이전 단계의 결과를 처리해주세요."
        }

        Coordinator.send_task(state.agent_id, agent.id, worker_pid, task_attrs)

      {:error, _} = error ->
        error
    end
  end

  defp find_worker_pid(state, agent_id) do
    case Enum.find(state.worker_agents, fn {agent, _pid} -> agent.id == agent_id end) do
      {_agent, pid} -> {:ok, pid}
      nil -> {:error, :worker_not_found}
    end
  end

  defp find_worker_by_name(state, worker_name) do
    case Enum.find(state.worker_agents, fn {agent, _pid} -> agent.name == worker_name end) do
      {agent, pid} -> {:ok, agent, pid}
      nil -> {:error, :worker_not_found}
    end
  end

  defp save_message(conversation_id, attrs) do
    attrs_with_conv = Map.put(attrs, :conversation_id, conversation_id)

    %Message{}
    |> Message.changeset(attrs_with_conv)
    |> Repo.insert()
  end

  defp record_performance_metric(state, worker_name, duration_ms, success) do
    # 타임스탬프 기반 고유 키 생성
    key = "task_#{DateTime.utc_now() |> DateTime.to_unix()}"

    value = %{
      worker_used: worker_name,
      duration_ms: duration_ms,
      success: success,
      timestamp: DateTime.utc_now() |> DateTime.to_iso8601()
    }

    opts = [
      conversation_id: state.conversation_id,
      relevance_score: 0.5
    ]

    case MemoryManager.store(state.agent_id, :performance_metric, key, value, opts) do
      {:ok, _memory} ->
        Logger.debug("Recorded performance metric: #{worker_name} (#{duration_ms}ms, #{success})")

      {:error, reason} ->
        Logger.warning("Failed to record performance metric: #{inspect(reason)}")
    end
  end

  defp record_error_pattern(state, user_request, error_reason) do
    # 오류에서 간단한 키 생성
    error_type = inspect(error_reason) |> String.slice(0, 50)
    key = "error_#{:erlang.phash2(error_type)}"

    value = %{
      user_request: user_request,
      error: inspect(error_reason),
      timestamp: DateTime.utc_now() |> DateTime.to_iso8601(),
      frequency: 1
    }

    # 이 오류 패턴이 이미 존재하는지 확인
    existing = MemoryManager.retrieve(state.agent_id, :learned_pattern, key: key)

    value =
      case existing do
        [memory | _] ->
          # 빈도 증가
          old_value = memory.value
          %{value | frequency: Map.get(old_value, "frequency", 1) + 1}

        [] ->
          value
      end

    opts = [
      conversation_id: state.conversation_id,
      relevance_score: 0.7
    ]

    case MemoryManager.store(state.agent_id, :learned_pattern, key, value, opts) do
      {:ok, _memory} ->
        Logger.debug("Recorded error pattern: #{key}")

      {:error, reason} ->
        Logger.warning("Failed to record error pattern: #{inspect(reason)}")
    end
  end
end
