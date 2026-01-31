defmodule Core.Agent.ToolRegistry do
  @moduledoc """
  Registry for available tools that the agent can use.
  Tools follow the OpenAI function calling specification.
  """

  alias Core.Agent.Tools

  @tools %{
    "get_current_time" => Tools.DateTime,
    "search_web" => Tools.WebSearch,
    "calculate" => Tools.Calculator,
    "read_file" => Tools.FileSystem,
    "write_file" => Tools.FileSystem,
    "list_directory" => Tools.FileSystem,
    "execute_code" => Tools.CodeExecutor,
    # Firecrawl MCP tools
    "firecrawl_scrape" => Tools.Firecrawl,
    "firecrawl_search" => Tools.Firecrawl
  }

  @doc """
  Get all available tools with their definitions.
  """
  def get_tools do
    @tools
    |> Enum.map(fn {name, module} ->
      apply(module, :definition, [name])
    end)
    |> Enum.filter(& &1)
  end

  @doc """
  Execute a tool by name with given arguments.
  """
  def execute(tool_name, arguments) do
    case Map.get(@tools, tool_name) do
      nil ->
        {:error, :tool_not_found}

      module ->
        try do
          apply(module, :execute, [tool_name, arguments])
        rescue
          e -> {:error, Exception.message(e)}
        end
    end
  end

  @doc """
  Check if a tool exists.
  """
  def tool_exists?(tool_name) do
    Map.has_key?(@tools, tool_name)
  end
end
