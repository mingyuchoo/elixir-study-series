defmodule Mix.Tasks.Hello do
  @moduledoc """
  The hello mix task: `mix help hello`
  """
  use Mix.Task

  @shortdoc "Simple runs the Hello.say/0 command."
  def run(_) do
    Hello.say()
  end
end
