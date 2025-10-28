defmodule Example do
  @moduledoc """
  """

  @doc """
  Erlang 모듈은 `:os`와 `:timer`와 같이
  소문자 아톰으로 표현됩니다.
  """
  def timed(fun, args) do
    {time, result} = :timer.tc(fun, args)
    IO.puts("Time: #{time} μs")
    IO.puts("Result: #{result}")
  end
end

Example.timed(fn n -> n * n * n end, [100])
