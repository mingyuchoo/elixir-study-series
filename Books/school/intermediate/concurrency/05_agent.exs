defmodule Example do
  @moduledoc """
  Agents are an abstraction around background processes maintaining state.
  : Agent == state

  ## Examples
      iex> c "filename.exs"
  """

  @doc """
  ## Examples
      iex> Example.get_state
      [1, 2, 3, 4, 5]
      [1, 2, 3, 4, 5]
  """
  def get_state do
    {:ok, agent} = Agent.start_link(fn -> [1, 2, 3] end)
    Agent.update(agent, fn state -> state ++ [4, 5] end)
    Agent.get(agent, & &1) |> IO.inspect()
  end

  @doc """
  ## Examples
      iex> Example.get_named_state
      [1, 2, 3, 4, 5]
      [1, 2, 3, 4, 5]
  """
  def get_named_state do
    Agent.start_link(fn -> [1, 2, 3] end, name: Numbers)
    Agent.update(Numbers, fn state -> state ++ [4, 5] end)
    Agent.get(Numbers, & &1) |> IO.inspect()
  end
end
