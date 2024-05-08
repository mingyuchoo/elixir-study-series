defmodule Sequence.Server do
  use GenServer

  @vsn "0"

  @me __MODULE__

  def start_link _ do
    GenServer.start_link(@me, nil, name: @me)
  end

  def next_number do
    GenServer.call @me, :next_number
  end

  def increment_number delta do
    GenServer.cast @me, {:increment_number, delta}
  end

  def init _ do
    {:ok, Sequence.Stash.get()}
  end

  def handle_call :next_number, _from, current_number do
    {:reply, current_number, current_number+1}
  end

  def handle_cast {:increment_number, delta}, current_number do
    {:noreply, current_number + delta}
  end

  def terminate _reason, current_number do
    Sequence.Stash.update(current_number)
  end
end
