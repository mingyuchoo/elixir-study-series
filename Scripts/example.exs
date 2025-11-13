#!/usr/bin/env elixir

defmodule ScriptExample do
  def main(args) do
    IO.puts("Input args: #{inspect(args)}")

    # Simple calculation
    result = Enum.sum([1, 2, 3, 4, 5])
    IO.puts("Sum: #{result}")

    # File processing
    case File.read("data.txt") do
      {:ok, content} -> IO.puts("File content: #{content}")
      {:error, _} -> IO.puts("Can NOT read the file")
    end
  end
end

# Run script
ScriptExample.main(System.argv())
