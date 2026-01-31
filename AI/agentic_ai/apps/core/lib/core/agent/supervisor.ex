defmodule Core.Agent.Supervisor do
  @moduledoc """
  Supervisor for agent processes.

  Manages both single-agent Workers (legacy) and multi-agent SupervisorAgents.
  """
  use DynamicSupervisor

  def start_link(init_arg) do
    DynamicSupervisor.start_link(__MODULE__, init_arg, name: __MODULE__)
  end

  @impl true
  def init(_init_arg) do
    DynamicSupervisor.init(strategy: :one_for_one)
  end

  @doc """
  Starts a SupervisorAgent for a conversation.

  ## Parameters

    - `agent_id` - Supervisor 에이전트 ID
    - `conversation_id` - 대화 ID

  ## Returns

    - `{:ok, pid}` - 성공 시 프로세스 PID
    - `{:error, reason}` - 실패 시 오류 원인
  """
  def start_supervisor_agent(agent_id, conversation_id) do
    spec = {Core.Agent.SupervisorAgent, agent_id: agent_id, conversation_id: conversation_id}
    DynamicSupervisor.start_child(__MODULE__, spec)
  end

  @doc """
  Starts a single Worker agent for a conversation (legacy).

  This function is kept for backward compatibility.
  For multi-agent systems, use `start_supervisor_agent/2` instead.
  """
  def start_agent(conversation_id) do
    spec = {Core.Agent.Worker, conversation_id: conversation_id}
    DynamicSupervisor.start_child(__MODULE__, spec)
  end

  def stop_agent(pid) do
    DynamicSupervisor.terminate_child(__MODULE__, pid)
  end
end
