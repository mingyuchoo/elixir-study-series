defmodule Sequence.Stash do
  use GenServer

  @me __MODULE__

  # API 함수

  @doc """
  스태시 서버를 시작합니다.
  """
  def start_link(initial_number) do
    GenServer.start_link(@me, initial_number, name: @me)
  end

  @doc """
  현재 저장된 숫자를 가져옵니다.
  """
  def get do
    GenServer.call(@me, :get)
  end

  @doc """
  새로운 숫자로 업데이트합니다.
  """
  def update(new_number) do
    GenServer.cast(@me, {:update, new_number})
  end

  # 콜백 함수

  @impl GenServer
  def init(initial_number) do
    {:ok, initial_number}
  end

  @impl GenServer
  def handle_call(:get, _from, current_number) do
    {:reply, current_number, current_number}
  end

  @impl GenServer
  def handle_cast({:update, new_number}, _current_number) do
    {:noreply, new_number}
  end
end
