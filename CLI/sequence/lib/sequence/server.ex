defmodule Sequence.Server do
  use GenServer

  @vsn "1"  # OTP 27 호환성을 위해 버전 업데이트

  @me __MODULE__

  # API 함수

  @doc """
  서버를 시작합니다.
  """
  def start_link(_) do
    GenServer.start_link(@me, nil, name: @me)
  end

  @doc """
  현재 숫자를 반환하고 1 증가시킵니다.
  """
  def next_number do
    GenServer.call(@me, :next_number)
  end

  @doc """
  현재 숫자를 주어진 값만큼 증가시킵니다.
  """
  def increment_number(delta) do
    GenServer.cast(@me, {:increment_number, delta})
  end

  # 콜백 함수

  @impl GenServer
  def init(_) do
    {:ok, Sequence.Stash.get()}
  end

  @impl GenServer
  def handle_call(:next_number, _from, current_number) do
    {:reply, current_number, current_number + 1}
  end

  @impl GenServer
  def handle_cast({:increment_number, delta}, current_number) do
    {:noreply, current_number + delta}
  end

  @impl GenServer
  def terminate(_reason, current_number) do
    Sequence.Stash.update(current_number)
  end
end
