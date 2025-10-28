defmodule WebCrawler.CLI do
  @moduledoc """
  웹 크롤러 명령줄 인터페이스

  `mix run` 명령으로 웹 크롤러를 실행할 수 있게 해주는 모듈입니다.
  """

  @doc """
  명령줄 인자를 파싱하고 웹 크롤러를 실행합니다.
  """
  def main(args \\ []) do
    {opts, urls, _} = OptionParser.parse(args,
      switches: [
        help: :boolean,
        max_depth: :integer,
        save_to: :string,
        filter_domain: :string
      ],
      aliases: [
        h: :help,
        d: :max_depth,
        s: :save_to,
        f: :filter_domain
      ]
    )

    case {opts, urls} do
      {[help: true], _} -> print_help()
      {_, []} -> print_help()
      {_, [url | _]} -> process_url(url, opts)
    end
  end

  defp process_url(url, opts) do
    IO.puts("\n크롤링 시작: #{url}")

    options = [
      max_depth: Keyword.get(opts, :max_depth, 1),
      save_to_file: Keyword.get(opts, :save_to)
    ]

    options = case Keyword.get(opts, :filter_domain) do
      nil -> options
      domain ->
        filter_fn = fn url -> String.contains?(url, domain) end
        Keyword.put(options, :filter, filter_fn)
    end

    case WebCrawler.start(url, options) do
      {:ok, count} -> IO.puts("\n크롤링 완료: #{count}개의 URL을 찾았습니다.")
      _ -> IO.puts("\n크롤링 중 오류가 발생했습니다.")
    end
  end

  defp print_help do
    IO.puts("""
    웹 크롤러 사용법:

    mix run -e 'WebCrawler.CLI.main()' -- [옵션] URL

    옵션:
      -h, --help            도움말 출력
      -d, --max_depth N     최대 크롤링 깊이 (기본값: 1)
      -s, --save_to FILE    결과를 파일에 저장
      -f, --filter_domain D 특정 도메인으로 필터링

    예제:
      mix run -e 'WebCrawler.CLI.main()' -- https://example.com
      mix run -e 'WebCrawler.CLI.main()' -- -d 2 https://example.com
      mix run -e 'WebCrawler.CLI.main()' -- -s urls.txt https://example.com
      mix run -e 'WebCrawler.CLI.main()' -- -f example.com https://example.com
    """)
  end
end
