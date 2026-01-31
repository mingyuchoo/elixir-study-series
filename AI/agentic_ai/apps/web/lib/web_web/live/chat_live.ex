defmodule WebWeb.ChatLive do
  use WebWeb, :live_view

  alias Core.Schema.{Conversation, Message}
  alias Core.Repo
  alias Core.Agent.{Supervisor, SupervisorAgent}
  alias Core.Contexts.{Agents, Mcps}

  import Ecto.Query

  # Markdown 렌더링 옵션
  @earmark_options %Earmark.Options{
    code_class_prefix: "language-",
    smartypants: false,
    breaks: true
  }

  @impl true
  def mount(_params, _session, socket) do
    conversations = list_conversations()
    available_agents = Agents.list_agents(status: :active)
    available_mcps = Mcps.list_mcps_with_status()

    socket =
      socket
      |> assign(:conversations, conversations)
      |> assign(:current_conversation, nil)
      |> assign(:messages, [])
      |> assign(:input, "")
      |> assign(:loading, false)
      |> assign(:available_agents, available_agents)
      |> assign(:available_mcps, available_mcps)
      |> assign(:agent_usage_history, [])

    {:ok, socket}
  end

  @impl true
  def handle_params(%{"id" => id}, _uri, socket) do
    conversation = Repo.get!(Conversation, id)
    messages = list_messages(id)
    agent_usage_history = Agents.list_agent_usage_history(id)

    # 실행 중이 아니면 에이전트 시작
    ensure_agent_started(id)

    socket =
      socket
      |> assign(:current_conversation, conversation)
      |> assign(:messages, messages)
      |> assign(:agent_usage_history, agent_usage_history)

    {:noreply, socket}
  end

  def handle_params(_params, _uri, socket) do
    {:noreply, socket}
  end

  @impl true
  def handle_event("new_conversation", _params, socket) do
    {:ok, conversation} =
      %Conversation{}
      |> Conversation.changeset(%{
        title: "New Chat #{DateTime.utc_now() |> DateTime.to_string()}"
      })
      |> Repo.insert()

    socket =
      socket
      |> assign(:conversations, list_conversations())
      |> push_navigate(to: ~p"/chat/#{conversation.id}")

    {:noreply, socket}
  end

  @impl true
  def handle_event("select_conversation", %{"id" => id}, socket) do
    {:noreply, push_navigate(socket, to: ~p"/chat/#{id}")}
  end

  @impl true
  def handle_event("delete_conversation", %{"id" => id}, socket) do
    conversation = Repo.get!(Conversation, id)

    # 실행 중인 에이전트 종료
    case Registry.lookup(Core.Agent.Registry, {:supervisor, id}) do
      [{pid, _}] -> Supervisor.stop_agent(pid)
      _ -> :ok
    end

    # 관련 메시지 먼저 삭제
    Message
    |> where([m], m.conversation_id == ^id)
    |> Repo.delete_all()

    # 대화 삭제
    Repo.delete!(conversation)

    # 현재 보고 있던 대화를 삭제한 경우 목록으로 이동
    socket =
      if socket.assigns.current_conversation && socket.assigns.current_conversation.id == id do
        socket
        |> assign(:conversations, list_conversations())
        |> assign(:current_conversation, nil)
        |> assign(:messages, [])
        |> push_navigate(to: ~p"/chat")
      else
        assign(socket, :conversations, list_conversations())
      end

    {:noreply, put_flash(socket, :info, "대화가 삭제되었습니다.")}
  end

  @impl true
  def handle_event("update_input", %{"message" => value}, socket) do
    {:noreply, assign(socket, :input, value)}
  end

  @impl true
  def handle_event("send_message", _params, socket) do
    input = String.trim(socket.assigns.input)

    if input != "" and socket.assigns.current_conversation do
      conversation_id = socket.assigns.current_conversation.id

      # UI 즉시 업데이트
      user_message = %{
        id: Ecto.UUID.generate(),
        role: :user,
        content: input,
        inserted_at: DateTime.utc_now()
      }

      socket =
        socket
        |> assign(:messages, socket.assigns.messages ++ [user_message])
        |> assign(:input, "")
        |> assign(:loading, true)

      # 에이전트에게 비동기로 전송
      send(self(), {:process_message, conversation_id, input})

      {:noreply, socket}
    else
      {:noreply, socket}
    end
  end

  @impl true
  def handle_info({:process_message, conversation_id, input}, socket) do
    case SupervisorAgent.chat(conversation_id, input) do
      {:ok, response} ->
        assistant_message = %{
          id: Ecto.UUID.generate(),
          role: :assistant,
          content: response,
          inserted_at: DateTime.utc_now()
        }

        # 처리 후 에이전트 사용 이력 리로드
        agent_usage_history = Agents.list_agent_usage_history(conversation_id)

        socket =
          socket
          |> assign(:messages, socket.assigns.messages ++ [assistant_message])
          |> assign(:loading, false)
          |> assign(:agent_usage_history, agent_usage_history)

        {:noreply, socket}

      {:error, reason} ->
        socket =
          socket
          |> assign(:loading, false)
          |> put_flash(:error, "Error: #{inspect(reason)}")

        {:noreply, socket}
    end
  end

  # 비공개 함수들

  defp list_conversations do
    Conversation
    |> order_by([c], desc: c.inserted_at)
    |> limit(20)
    |> Repo.all()
  end

  defp list_messages(conversation_id) do
    Message
    |> where([m], m.conversation_id == ^conversation_id)
    |> order_by([m], asc: m.inserted_at)
    |> Repo.all()
  end

  defp ensure_agent_started(conversation_id) do
    case Registry.lookup(Core.Agent.Registry, {:supervisor, conversation_id}) do
      [] ->
        # 활성화된 supervisor 에이전트 가져오기
        case Agents.get_active_supervisor() do
          nil ->
            # 폴백: supervisor가 설정되지 않음
            :ok

          supervisor ->
            Supervisor.start_supervisor_agent(supervisor.id, conversation_id)
        end

      _ ->
        :ok
    end
  end

  @impl true
  def render(assigns) do
    ~H"""
    <div class="flex h-screen bg-gray-100">
      <!-- Sidebar -->
      <div class="w-64 bg-gray-900 text-white flex flex-col">
        <div class="p-4 border-b border-gray-700">
          <button
            phx-click="new_conversation"
            class="w-full py-2 px-4 bg-blue-600 hover:bg-blue-700 rounded-lg transition"
          >
            + New Chat
          </button>
        </div>

        <div class="flex-1 overflow-y-auto">
          <%= for conv <- @conversations do %>
            <div class={"group flex items-center justify-between p-3 cursor-pointer hover:bg-gray-800 border-b border-gray-700 #{if @current_conversation && @current_conversation.id == conv.id, do: "bg-gray-700", else: ""}"}>
              <div
                phx-click="select_conversation"
                phx-value-id={conv.id}
                class="flex-1 min-w-0"
              >
                <div class="truncate text-sm">{conv.title}</div>
                <div class="text-xs text-gray-400">
                  {Calendar.strftime(conv.inserted_at, "%Y-%m-%d %H:%M")}
                </div>
              </div>
              <button
                phx-click="delete_conversation"
                phx-value-id={conv.id}
                data-confirm="이 대화를 삭제하시겠습니까? 모든 메시지가 함께 삭제됩니다."
                class="ml-2 p-1 text-gray-500 hover:text-red-400 opacity-0 group-hover:opacity-100 transition-opacity"
                title="대화 삭제"
              >
                <.icon name="hero-trash" class="w-4 h-4" />
              </button>
            </div>
          <% end %>
        </div>
        
    <!-- MCP Panel -->
        <div class="border-t border-gray-700 p-3">
          <div class="text-xs font-semibold text-gray-400 uppercase tracking-wider mb-2">
            사용 가능한 MCP
          </div>
          <%= if @available_mcps == [] do %>
            <div class="text-xs text-gray-500 italic p-2">
              설정된 MCP가 없습니다
            </div>
          <% else %>
            <div class="space-y-1">
              <%= for mcp <- @available_mcps do %>
                <div class="flex items-center gap-2 p-2 rounded text-sm bg-gray-800 hover:bg-gray-700 transition">
                  <span class="flex items-center justify-center w-5 h-5 bg-purple-600 text-white text-xs rounded">
                    <.icon name="hero-server" class="w-3 h-3" />
                  </span>
                  <div class="flex-1 min-w-0">
                    <div class="truncate font-medium text-purple-300">
                      {mcp.name}
                    </div>
                    <div class="truncate text-xs text-gray-400">
                      {mcp.command} {Enum.join(mcp.args, " ")}
                    </div>
                  </div>
                  <!-- 신호등 상태 표시 -->
                  <span class={mcp_status_indicator_class(mcp.status)} title={mcp_status_label(mcp.status)}>
                    <span class={mcp_status_dot_class(mcp.status)}></span>
                  </span>
                </div>
              <% end %>
            </div>
          <% end %>
        </div>
        
    <!-- Agent Panel -->
        <div class="border-t border-gray-700 p-3">
          <div class="text-xs font-semibold text-gray-400 uppercase tracking-wider mb-2">
            사용 가능한 에이전트
          </div>
          <div class="space-y-1">
            <%= for agent <- @available_agents do %>
              <% usage_info = find_agent_usage(@agent_usage_history, agent.id) %>
              <div class={"flex items-center gap-2 p-2 rounded text-sm #{if usage_info, do: "bg-gray-700", else: "bg-gray-800"}"}>
                <%= if usage_info do %>
                  <span class="flex items-center justify-center w-5 h-5 bg-blue-600 text-white text-xs font-bold rounded-full">
                    {usage_info.order}
                  </span>
                <% else %>
                  <span class="flex items-center justify-center w-5 h-5 bg-gray-600 text-gray-400 text-xs rounded-full">
                    -
                  </span>
                <% end %>
                <div class="flex-1 min-w-0">
                  <div class="truncate font-medium">
                    {agent.display_name || agent.name}
                  </div>
                  <%= if agent.description do %>
                    <div class="truncate text-xs text-gray-400">
                      {agent.description}
                    </div>
                  <% end %>
                </div>
                <%= if usage_info do %>
                  <span class="text-xs text-green-400" title="사용됨">
                    <.icon name="hero-check-circle" class="w-4 h-4" />
                  </span>
                <% end %>
              </div>
            <% end %>
          </div>

          <%= if @agent_usage_history != [] do %>
            <div class="mt-3 pt-3 border-t border-gray-700">
              <div class="text-xs font-semibold text-gray-400 uppercase tracking-wider mb-2">
                실행 순서
              </div>
              <div class="flex flex-wrap gap-1">
                <%= for usage <- @agent_usage_history do %>
                  <span
                    class="inline-flex items-center gap-1 px-2 py-1 bg-blue-600/20 text-blue-300 text-xs rounded"
                    title={Calendar.strftime(usage.timestamp, "%H:%M:%S")}
                  >
                    <span class="font-bold">{usage.order}.</span>
                    {usage.agent.display_name || usage.agent.name}
                  </span>
                <% end %>
              </div>
            </div>
          <% end %>
        </div>
      </div>
      
    <!-- Main Chat Area -->
      <div class="flex-1 flex flex-col">
        <!-- Header -->
        <div class="bg-white border-b p-4 shadow-sm">
          <div class="flex items-center justify-between">
            <div>
              <h1 class="text-xl font-semibold text-gray-800">
                {if @current_conversation,
                  do: @current_conversation.title,
                  else: "Agentic AI Assistant"}
              </h1>
              <p class="text-sm text-gray-500">Powered by Azure OpenAI gpt-5-mini</p>
            </div>
            <%= if @current_conversation do %>
              <button
                phx-click="delete_conversation"
                phx-value-id={@current_conversation.id}
                data-confirm="이 대화를 삭제하시겠습니까? 모든 메시지가 함께 삭제됩니다."
                class="flex items-center gap-2 px-3 py-2 text-red-600 hover:text-red-700 hover:bg-red-50 border border-red-200 rounded-lg transition"
                title="대화 삭제"
              >
                <.icon name="hero-trash" class="w-4 h-4" />
                <span class="text-sm">삭제</span>
              </button>
            <% end %>
          </div>
        </div>
        
    <!-- Messages -->
        <div class="flex-1 overflow-y-auto p-4 space-y-4" id="messages">
          <%= if @messages == [] and @current_conversation do %>
            <div class="text-center text-gray-500 mt-8">
              <p class="text-lg">Start a conversation!</p>
              <p class="text-sm">The assistant can help you with various tasks using tools.</p>
            </div>
          <% end %>

          <%= for message <- @messages do %>
            <div class={message_container_class(message.role)}>
              <div class={message_bubble_class(message.role)}>
                <div class="text-xs text-gray-500 mb-1">
                  {role_label(message.role)}
                </div>
                <%= if message.role in [:assistant, "assistant"] do %>
                  <div class="prose prose-sm max-w-none prose-headings:text-gray-800 prose-p:text-gray-700 prose-code:text-pink-600 prose-pre:bg-gray-800 prose-pre:text-gray-100 prose-a:text-blue-600 prose-strong:text-gray-900 prose-li:text-gray-700">
                    {render_markdown(message.content)}
                  </div>
                <% else %>
                  <div class="whitespace-pre-wrap">{message.content}</div>
                <% end %>
              </div>
            </div>
          <% end %>

          <%= if @loading do %>
            <div class="flex justify-start">
              <div class="bg-gray-200 rounded-lg p-4">
                <div class="flex items-center space-x-2">
                  <div class="animate-pulse flex space-x-1">
                    <div class="w-2 h-2 bg-gray-500 rounded-full"></div>
                    <div class="w-2 h-2 bg-gray-500 rounded-full"></div>
                    <div class="w-2 h-2 bg-gray-500 rounded-full"></div>
                  </div>
                  <span class="text-sm text-gray-500">Thinking...</span>
                </div>
              </div>
            </div>
          <% end %>
        </div>
        
    <!-- Input -->
        <%= if @current_conversation do %>
          <div class="bg-white border-t p-4">
            <form phx-submit="send_message" phx-change="update_input" class="flex space-x-4">
              <input
                type="text"
                name="message"
                value={@input}
                placeholder="Type your message..."
                disabled={@loading}
                class="flex-1 border rounded-lg px-4 py-2 focus:outline-none focus:ring-2 focus:ring-blue-500"
                autocomplete="off"
              />
              <button
                type="submit"
                disabled={@loading or @input == ""}
                class="bg-blue-600 hover:bg-blue-700 disabled:bg-gray-400 text-white px-6 py-2 rounded-lg transition"
              >
                Send
              </button>
            </form>
          </div>
        <% else %>
          <div class="bg-white border-t p-4 text-center text-gray-500">
            Select a conversation or create a new one to start chatting.
          </div>
        <% end %>
      </div>
    </div>
    """
  end

  defp message_container_class(role) when role in [:user, "user"], do: "flex justify-end"
  defp message_container_class(_), do: "flex justify-start"

  defp message_bubble_class(role) when role in [:user, "user"],
    do: "max-w-[70%] rounded-lg p-4 bg-blue-600 text-white"

  defp message_bubble_class(role) when role in [:assistant, "assistant"],
    do: "max-w-[70%] rounded-lg p-4 bg-gray-200 text-gray-800"

  defp message_bubble_class(role) when role in [:tool, "tool"],
    do: "max-w-[70%] rounded-lg p-4 bg-yellow-100 text-gray-800 border border-yellow-300"

  defp message_bubble_class(_), do: "max-w-[70%] rounded-lg p-4 bg-gray-100 text-gray-800"

  defp role_label(role) when role in [:user, "user"], do: "You"
  defp role_label(role) when role in [:assistant, "assistant"], do: "Assistant"
  defp role_label(role) when role in [:tool, "tool"], do: "Tool Result"
  defp role_label(_), do: "System"

  defp find_agent_usage(usage_history, agent_id) do
    Enum.find(usage_history, fn usage ->
      usage.agent && usage.agent.id == agent_id
    end)
  end

  # Markdown을 HTML로 렌더링
  defp render_markdown(nil), do: Phoenix.HTML.raw("")

  defp render_markdown(content) when is_binary(content) do
    content
    |> Earmark.as_html!(@earmark_options)
    |> Phoenix.HTML.raw()
  end

  defp render_markdown(_), do: Phoenix.HTML.raw("")

  # MCP 상태 표시기 스타일
  defp mcp_status_indicator_class(status) do
    base = "flex items-center justify-center w-5 h-5 rounded-full"

    case status do
      :ready -> "#{base} bg-green-500/20"
      :unavailable -> "#{base} bg-red-500/20"
      :unknown -> "#{base} bg-gray-500/20"
      _ -> "#{base} bg-gray-500/20"
    end
  end

  defp mcp_status_dot_class(status) do
    base = "w-2.5 h-2.5 rounded-full"

    case status do
      :ready -> "#{base} bg-green-500 shadow-lg shadow-green-500/50"
      :unavailable -> "#{base} bg-red-500 shadow-lg shadow-red-500/50"
      :unknown -> "#{base} bg-gray-500"
      _ -> "#{base} bg-gray-500"
    end
  end

  defp mcp_status_label(status) do
    case status do
      :ready -> "사용 가능"
      :unavailable -> "환경 변수 미설정"
      :unknown -> "상태 확인 불가"
      _ -> "알 수 없음"
    end
  end
end
