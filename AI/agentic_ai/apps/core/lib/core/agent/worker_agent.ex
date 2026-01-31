defmodule Core.Agent.WorkerAgent do
  @moduledoc """
  Worker 에이전트 GenServer.

  Supervisor로부터 작업을 받아 실행하고 결과를 반환합니다.
  Agent 테이블의 설정을 기반으로 동작하며, enabled_tools만 사용합니다.
  """

  use GenServer
  require Logger

  alias Core.Agent.{ReactEngine, ToolRegistry}
  alias Core.Contexts.Agents
  alias Core.Schema.{Agent, AgentTask}
  alias Core.Repo

  defstruct [:agent_id, :agent, :tools, :current_task]

  # Client API

  @doc """
  WorkerAgent 프로세스를 시작합니다.

  ## Options

    - `:agent_id` - Agent 테이블의 에이전트 ID (필수)
  """
  def start_link(opts) do
    agent_id = Keyword.fetch!(opts, :agent_id)
    GenServer.start_link(__MODULE__, agent_id)
  end

  @doc """
  Worker에게 작업을 실행하도록 요청합니다.

  ## Parameters

    - `worker_pid` - Worker 프로세스 PID
    - `task_attrs` - 작업 정보
      - `:conversation_id` - 대화 ID
      - `:user_request` - 사용자 요청
      - `:context` - 추가 컨텍스트 (선택)

  ## Returns

    - `{:ok, result}` - 성공 시 작업 결과
    - `{:error, reason}` - 실패 시 오류 원인
  """
  def execute_task(worker_pid, task_attrs) do
    GenServer.call(worker_pid, {:execute_task, task_attrs}, 120_000)
  end

  # Server callbacks

  @impl true
  def init(agent_id) do
    case Agents.get_agent(agent_id) do
      nil ->
        {:stop, {:error, :agent_not_found}}

      %Agent{type: :worker} = agent ->
        tools = load_enabled_tools(agent)

        state = %__MODULE__{
          agent_id: agent_id,
          agent: agent,
          tools: tools,
          current_task: nil
        }

        Logger.info("WorkerAgent started: #{agent.name} (#{agent_id})")
        {:ok, state}

      %Agent{type: type} ->
        {:stop, {:error, {:invalid_agent_type, type}}}
    end
  end

  @impl true
  def handle_call({:execute_task, task_attrs}, _from, state) do
    Logger.info("WorkerAgent #{state.agent.name} received task: #{inspect(task_attrs)}")

    # Create AgentTask record
    {:ok, agent_task} = create_agent_task(state, task_attrs)
    state = %{state | current_task: agent_task}

    # Update task status to in_progress
    {:ok, agent_task} =
      agent_task
      |> AgentTask.changeset(%{status: :in_progress, started_at: DateTime.utc_now()})
      |> Repo.update()

    # Execute task using ReactEngine
    case run_task(state, task_attrs) do
      {:ok, result} ->
        # Update task status to completed
        {:ok, _agent_task} = update_task_status(agent_task, :completed, result)

        state = %{state | current_task: nil}
        {:reply, {:ok, result}, state}

      {:error, reason} = error ->
        # Update task status to failed
        {:ok, _agent_task} = update_task_status(agent_task, :failed, reason)

        state = %{state | current_task: nil}
        {:reply, error, state}
    end
  end

  # Private functions

  defp load_enabled_tools(%Agent{enabled_tools: enabled_tool_names}) do
    all_tools = ToolRegistry.get_tools()

    Enum.filter(all_tools, fn tool ->
      tool.name in enabled_tool_names
    end)
  end

  defp create_agent_task(state, task_attrs) do
    attrs = %{
      conversation_id: task_attrs[:conversation_id],
      supervisor_id: task_attrs[:supervisor_id],
      worker_id: state.agent_id,
      task_type: "execute",
      status: :pending,
      input_data: %{
        user_request: task_attrs[:user_request],
        context: task_attrs[:context]
      }
    }

    %AgentTask{}
    |> AgentTask.changeset(attrs)
    |> Repo.insert()
  end

  defp update_task_status(task, :completed, result) do
    attrs = %{
      status: :completed,
      output_data: %{result: result},
      completed_at: DateTime.utc_now()
    }

    task
    |> AgentTask.changeset(attrs)
    |> Repo.update()
  end

  defp update_task_status(task, :failed, error) do
    attrs = %{
      status: :failed,
      error_message: inspect(error),
      completed_at: DateTime.utc_now()
    }

    task
    |> AgentTask.changeset(attrs)
    |> Repo.update()
  end

  defp update_task_status(task, status, _extra) do
    attrs = %{status: status}

    task
    |> AgentTask.changeset(attrs)
    |> Repo.update()
  end

  defp run_task(state, task_attrs) do
    user_request = task_attrs[:user_request]
    context = task_attrs[:context]

    # Build initial messages
    messages = build_initial_messages(user_request, context)

    # Run ReactEngine
    opts = [
      system_prompt: state.agent.system_prompt,
      max_iterations: state.agent.max_iterations || 10
    ]

    case ReactEngine.run(messages, state.tools, opts) do
      {:ok, result, _final_messages} ->
        {:ok, result}

      {:error, reason} ->
        Logger.error("Task execution failed: #{inspect(reason)}")
        {:error, reason}
    end
  end

  defp build_initial_messages(user_request, context) do
    messages = []

    messages =
      if context do
        [
          %{
            role: "system",
            content: "Additional context: #{context}",
            tool_calls: nil,
            tool_call_id: nil
          }
          | messages
        ]
      else
        messages
      end

    messages ++
      [
        %{
          role: "user",
          content: user_request,
          tool_calls: nil,
          tool_call_id: nil
        }
      ]
  end
end
