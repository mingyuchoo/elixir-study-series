defmodule Example do
  @moduledoc """
  Connect process with `spawn_link/3`
  to receive exit signal
  ## Examples
      iex> c "filename.exs"
  """

  @doc """
  ## Examples
      iex> spawn(Example, :unexpected_work, [])
      #PID<0.66.0>
      iex> spawn_link(Example, :unexpected_work, [])
      ** (EXIT from #PID<0.57.0>) ....
  """
  def unexpected_work() do
    IO.puts("I'm working...")
    exit(:KABOOM)
  end

  @doc """
  ## Examples
      iex> Example.run
      Exit reason: KABOOM
      :ok
  """
  def run do
    Process.flag(:trap_exit, true)
    spawn_link(Example, :unexpected_work, [])

    receive do
      {:EXIT, _from_pid, reason} -> IO.puts("Exit reason: #{reason}")
    end
  end
end
