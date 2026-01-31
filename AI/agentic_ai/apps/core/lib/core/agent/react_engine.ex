defmodule Core.Agent.ReactEngine do
  @moduledoc """
  ReAct (Reasoning + Acting) 패턴 엔진.

  에이전트가 도구를 사용하며 작업을 수행하는 핵심 로직을 제공합니다.
  순수 함수 기반으로 설계되어 다양한 에이전트 타입에서 재사용 가능합니다.
  """

  require Logger
  alias Core.LLM.AzureOpenAI
  alias Core.Agent.ToolRegistry

  @type message :: %{
          role: String.t(),
          content: String.t(),
          tool_calls: list() | nil,
          tool_call_id: String.t() | nil
        }

  @type tool :: %{
          name: String.t(),
          description: String.t(),
          parameters: map()
        }

  @type result ::
          {:ok, String.t(), list(message())}
          | {:error, atom() | String.t()}

  @doc """
  ReAct 루프를 실행합니다.

  ## Parameters

    - `messages`: 대화 메시지 목록
    - `tools`: 사용 가능한 도구 목록
    - `opts`: 옵션
      - `:max_iterations` - 최대 반복 횟수 (기본값: 10)
      - `:system_prompt` - 시스템 프롬프트 (기본값: nil)

  ## Returns

    - `{:ok, response, messages}` - 성공 시 최종 응답과 업데이트된 메시지 목록
    - `{:error, reason}` - 실패 시 오류 원인

  ## Examples

      iex> ReactEngine.run([], tools, system_prompt: "You are a helpful assistant")
      {:ok, "안녕하세요!", [%{role: "assistant", content: "안녕하세요!", ...}]}
  """
  @spec run(list(message()), list(tool()), keyword()) :: result()
  def run(messages, tools, opts \\ []) do
    max_iterations = Keyword.get(opts, :max_iterations, 10)
    system_prompt = Keyword.get(opts, :system_prompt)

    messages_with_system =
      if system_prompt do
        [%{role: "system", content: system_prompt} | messages]
      else
        messages
      end

    agent_loop(messages_with_system, tools, 0, max_iterations)
  end

  # 비공개 함수들

  defp agent_loop(_messages, _tools, iteration, max_iterations)
       when iteration >= max_iterations do
    Logger.warning("Max iterations (#{max_iterations}) reached")
    {:error, :max_iterations_reached}
  end

  defp agent_loop(messages, tools, iteration, max_iterations) do
    formatted_messages = format_messages_for_api(messages)
    formatted_tools = format_tools_for_api(tools)

    case AzureOpenAI.chat_completion(formatted_messages, tools: formatted_tools) do
      {:ok, %{tool_calls: nil, content: content}} ->
        # 도구 호출 없음 - 최종 응답 반환
        assistant_message = %{
          role: "assistant",
          content: content,
          tool_calls: nil,
          tool_call_id: nil
        }

        {:ok, content, messages ++ [assistant_message]}

      {:ok, %{tool_calls: tool_calls, content: content}} when is_list(tool_calls) ->
        # 도구 호출 존재 - 도구 실행 후 루프 계속
        assistant_message = %{
          role: "assistant",
          content: content || "",
          tool_calls: tool_calls,
          tool_call_id: nil
        }

        messages_after_assistant = messages ++ [assistant_message]
        messages_after_tools = execute_tool_calls(messages_after_assistant, tool_calls)

        agent_loop(messages_after_tools, tools, iteration + 1, max_iterations)

      {:error, reason} ->
        Logger.error("LLM API call failed: #{inspect(reason)}")
        {:error, reason}
    end
  end

  defp execute_tool_calls(messages, tool_calls) do
    tool_messages =
      Enum.map(tool_calls, fn tool_call ->
        function_name = tool_call["function"]["name"]
        arguments = Jason.decode!(tool_call["function"]["arguments"])

        Logger.info("Executing tool: #{function_name} with args: #{inspect(arguments)}")

        result =
          case ToolRegistry.execute(function_name, arguments) do
            {:ok, result} ->
              Jason.encode!(result)

            {:error, reason} ->
              Logger.warning("Tool execution failed: #{inspect(reason)}")
              Jason.encode!(%{error: inspect(reason)})
          end

        %{
          role: "tool",
          content: result,
          tool_calls: nil,
          tool_call_id: tool_call["id"]
        }
      end)

    messages ++ tool_messages
  end

  defp format_messages_for_api(messages) do
    Enum.map(messages, fn msg ->
      base = %{role: msg.role, content: msg.content}

      base
      |> maybe_add(:tool_calls, msg[:tool_calls])
      |> maybe_add(:tool_call_id, msg[:tool_call_id])
    end)
  end

  defp format_tools_for_api(tools) do
    Enum.map(tools, fn tool ->
      %{
        type: "function",
        function: %{
          name: tool.name,
          description: tool.description,
          parameters: tool.parameters
        }
      }
    end)
  end

  defp maybe_add(map, _key, nil), do: map
  defp maybe_add(map, _key, []), do: map
  defp maybe_add(map, key, value), do: Map.put(map, key, value)
end
