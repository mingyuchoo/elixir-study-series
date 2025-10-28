defmodule Example do
  def unexpected_work do
    IO.puts("I'm working...")
    exit(:KABOOM)
  end

  def run do
    spawn_monitor(Example, :unexpected_work, [])

    receive do
      {:DOWN, _ref, :process, _from_pid, reason} -> IO.puts("Exit reason: #{reason}")
    end
  end
end
