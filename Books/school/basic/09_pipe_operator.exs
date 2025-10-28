defmodule PipeOperators do
end

"Elixir rocks" |> String.upcase() |> String.split() |> IO.inspect()
"elixir" |> String.ends_with?("ixir") |> IO.inspect()
