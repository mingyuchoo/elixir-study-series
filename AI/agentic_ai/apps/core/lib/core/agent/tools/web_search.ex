defmodule Core.Agent.Tools.WebSearch do
  @moduledoc """
  Web search tool using DuckDuckGo instant answers API.
  """

  def definition("search_web") do
    %{
      name: "search_web",
      description: "Search the web for information. Returns relevant results from DuckDuckGo.",
      parameters: %{
        type: "object",
        properties: %{
          query: %{
            type: "string",
            description: "Search query"
          }
        },
        required: ["query"]
      }
    }
  end

  def definition(_), do: nil

  def execute("search_web", %{"query" => query}) do
    url = "https://api.duckduckgo.com/"

    case Req.get(url, params: [q: query, format: "json", no_redirect: 1]) do
      {:ok, %{status: 200, body: body}} ->
        results = parse_ddg_response(body)
        {:ok, %{query: query, results: results}}

      {:ok, %{status: status}} ->
        {:error, "Search failed with status #{status}"}

      {:error, reason} ->
        {:error, inspect(reason)}
    end
  end

  defp parse_ddg_response(body) when is_map(body) do
    results = []

    # Abstract (main answer)
    results =
      if body["Abstract"] && body["Abstract"] != "" do
        [
          %{
            type: "abstract",
            text: body["Abstract"],
            source: body["AbstractSource"],
            url: body["AbstractURL"]
          }
          | results
        ]
      else
        results
      end

    # Related topics
    related =
      (body["RelatedTopics"] || [])
      |> Enum.take(5)
      |> Enum.filter(&is_map/1)
      |> Enum.map(fn topic ->
        %{
          type: "related",
          text: topic["Text"],
          url: topic["FirstURL"]
        }
      end)

    results ++ related
  end

  defp parse_ddg_response(_), do: []
end
