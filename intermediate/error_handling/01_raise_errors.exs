defmodule RaiseErrors do
  @moduledoc """
  """

  @doc """
  Raising Error
  """
  def get_raise do
    raise "Oh, no!"
  end

  @doc """
  """
  def try_rescue do
    try do
      raise "Oh, no!"
    rescue
      e in RuntimeError -> IO.puts("An error occurred: " <> e.message)
    end
  end

  @doc """
  """
  def try_rescue_after do
    try do
      raise "Oh, no!"
    rescue
      e in RuntimeError -> IO.puts("An error occurred: " <> e.message)
    after
      IO.puts("The end!")
    end
  end
end

# RaiseErrors.get_raise()
RaiseErrors.try_rescue()
RaiseErrors.try_rescue_after()
