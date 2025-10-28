defmodule Duper do
  @moduledoc """
  Main entry point for the Duper application.
  Run with: mix run
  """

  def main(_args \\ []) do
    # Start the application supervision tree
    {:ok, _pid} = Duper.Application.start(:normal, [])
    # Prevent the process from immediately exiting
    Process.sleep(:infinity)
  end
end
