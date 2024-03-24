defmodule NewErrors do
  @moduledoc """
  """

  defexception message: "an example error has occurred"

  @doc """
  """
  def get_new_error do
    try do
      raise NewErrors
    rescue
      e in NewErrors -> e
    end
  end
end

NewErrors.get_new_error() |> IO.inspect()
