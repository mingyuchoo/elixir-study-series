defmodule WebCrawler do
  @moduledoc """
  웹 크롤러 모듈

  웹 페이지에서 URL을 추출하고 선택적으로 재귀적으로 크롤링하는 기능을 제공합니다.
  """

  @doc """
  주어진 URL에서 크롤링을 시작합니다.

  ## 매개변수

    * `url` - 크롤링할 웹 페이지의 URL
    * `options` - 크롤링 옵션 (기본값: `[]`)
      * `:max_depth` - 최대 크롤링 깊이 (기본값: 1)
      * `:filter` - URL 필터링 함수 (기본값: 모든 URL 허용)

  ## 예제

      iex> WebCrawler.start("https://example.com")
      # 추출된 URL 목록 출력

      iex> WebCrawler.start("https://example.com", max_depth: 2)
      # 두 레벨까지 재귀적으로 크롤링하여 URL 목록 출력
  """
  def start(url, options \\ []) do
    max_depth = Keyword.get(options, :max_depth, 1)
    filter_fn = Keyword.get(options, :filter, fn _ -> true end)
    save_to_file = Keyword.get(options, :save_to_file, nil)

    urls = crawl(url, max_depth, filter_fn, MapSet.new([url]))

    if save_to_file do
      save_results(urls, save_to_file)
    end

    urls
    |> Enum.each(&IO.puts/1)

    {:ok, Enum.count(urls)}
  end

  @doc """
  주어진 URL을 크롤링하고 추출된 URL을 반환합니다.

  ## 매개변수

    * `url` - 크롤링할 웹 페이지의 URL
    * `max_depth` - 최대 크롤링 깊이
    * `filter_fn` - URL 필터링 함수
    * `visited` - 이미 방문한 URL 집합
  """
  def crawl(url, max_depth, filter_fn, visited, current_depth \\ 1) do
    if current_depth > max_depth do
      visited
    else
      case fetch_url(url) do
        {:ok, body} ->
          links = extract_links(body, url)

          filtered_links = links
          |> Enum.filter(fn link -> filter_fn.(link) end)
          |> Enum.filter(fn link -> !MapSet.member?(visited, link) end)

          new_visited = Enum.reduce(filtered_links, visited, fn link, acc ->
            MapSet.put(acc, link)
          end)

          if current_depth < max_depth do
            Enum.reduce(filtered_links, new_visited, fn link, acc ->
              crawl(link, max_depth, filter_fn, acc, current_depth + 1)
            end)
          else
            new_visited
          end

        {:error, _reason} ->
          visited
      end
    end
  end

  @doc """
  URL에서 웹 페이지를 가져옵니다.
  """
  def fetch_url(url) do
    case HTTPoison.get(url, [], follow_redirect: true, max_redirects: 5) do
      {:ok, %HTTPoison.Response{status_code: 200, body: body}} -> 
        {:ok, body}
      {:ok, %HTTPoison.Response{status_code: status_code}} -> 
        IO.puts("\n[오류] 페이지 가져오기 실패. 상태 코드: #{status_code}, URL: #{url}")
        {:error, "Status code: #{status_code}"}
      {:error, %HTTPoison.Error{reason: reason}} -> 
        IO.puts("\n[오류] 요청 오류 발생: #{reason}, URL: #{url}")
        {:error, reason}
    end
  end

  @doc """
  HTML 본문에서 링크를 추출합니다.
  """
  def extract_links(body, base_url) do
    try do
      body
      |> Floki.parse_document!()
      |> Floki.find("a")
      |> Enum.map(&Floki.attribute(&1, "href"))
      |> List.flatten()
      |> Enum.filter(&is_binary/1)
      |> Enum.map(fn href -> normalize_url(href, base_url) end)
      |> Enum.filter(&is_valid_url?/1)
    rescue
      e ->
        IO.puts("\n[오류] HTML 파싱 오류: #{inspect(e)}, URL: #{base_url}")
        []
    end
  end

  @doc """
  상대 URL을 절대 URL로 변환합니다.
  """
  def normalize_url(href, base_url) do
    cond do
      String.starts_with?(href, "http://") || String.starts_with?(href, "https://") ->
        href
      String.starts_with?(href, "/") ->
        uri = URI.parse(base_url)
        "#{uri.scheme}://#{uri.host}#{href}"
      true ->
        base_uri = URI.parse(base_url)
        base_path = Path.dirname(base_uri.path || "/")
        "#{base_uri.scheme}://#{base_uri.host}#{base_path}/#{href}"
    end
  end

  @doc """
  URL이 유효한지 확인합니다.
  """
  def is_valid_url?(url) do
    case URI.parse(url) do
      %URI{scheme: nil} -> false
      %URI{host: nil} -> false
      %URI{scheme: scheme} when scheme not in ["http", "https"] -> false
      _ -> true
    end
  end

  @doc """
  추출된 URL을 파일에 저장합니다.
  """
  def save_results(urls, filename) do
    content = urls
    |> MapSet.to_list()
    |> Enum.join("\n")

    File.write(filename, content)
  end
end
