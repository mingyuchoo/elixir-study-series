defmodule Example do
  @moduledoc """
  Agents are an abstraction around background processes maintaining state.
  """

  def run do
    Agent.start_link(fn -> [1, 2, 3] end)
  end
end
