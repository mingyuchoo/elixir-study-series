defmodule WebCrawler do
  def start(url) do
    case HTTPoison.get(url) do
      {:ok, %HTTPoison.Response{status_code: 200, body: body}} -> parse_body(body)
      {:ok, %HTTPoison.Response{status_code: status_code}} -> IO.puts("Failed to fetch the page. Status code: #{status_code}")
      {:error, %HTTPoison.Error{reason: reason}} -> IO.puts("Error occurred:#{reason}")
    end
  end

  defp parse_body(body) do
    body
    |> Floki.parse_document!()
    |> Floki.find("a")
    |> Enum.map(&Floki.attribute(&1, "href"))
    |> Enum.each(&IO.puts/1)
  end
end
