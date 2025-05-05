# 웹 크롤러

이 프로젝트는 웹 페이지에서 URL을 추출하고 선택적으로 재귀적으로 크롤링하는 기능을 제공합니다.

## 기능

- 단일 페이지 URL 추출
- 재귀적 크롤링 (설정 가능한 깊이)
- URL 필터링
- 결과 파일 저장
- 중복 URL 방지

## 설치

이 패키지를 사용하려면 `mix.exs` 파일의 의존성 목록에 `web_crawler`를 추가하세요:

```elixir
def deps do
  [
    {:web_crawler, "~> 0.1.0"}
  ]
end
```

## 사용 방법

### 기본 사용법

```elixir
# 단일 페이지 크롤링
WebCrawler.start("https://example.com")

# 깊이 2로 재귀적 크롤링
WebCrawler.start("https://example.com", max_depth: 2)

# 결과를 파일에 저장
WebCrawler.start("https://example.com", save_to_file: "urls.txt")

# URL 필터링 (example.com 도메인만 크롤링)
filter_fn = fn url -> String.contains?(url, "example.com") end
WebCrawler.start("https://example.com", filter: filter_fn)
```

### 명령행 인터페이스

`mix run` 명령어를 사용하여 명령행 인터페이스를 통해 웹 크롤러를 사용할 수 있습니다:

```bash
# 도움말 보기
mix run -e 'WebCrawler.CLI.main()' -- --help

# 단일 페이지 크롤링
mix run -e 'WebCrawler.CLI.main()' -- https://example.com

# 깊이 2로 재귀적 크롤링
mix run -e 'WebCrawler.CLI.main()' -- -d 2 https://example.com

# 결과를 파일에 저장
mix run -e 'WebCrawler.CLI.main()' -- -s urls.txt https://example.com

# 도메인 필터링 (example.com 도메인만 크롤링)
mix run -e 'WebCrawler.CLI.main()' -- -f example.com https://example.com
```

옵션:
- `-h, --help` : 도움말 보기
- `-d, --max_depth N` : 최대 깊이 설정 (기본값: 1)
- `-s, --save_to FILE` : 결과를 파일에 저장
- `-f, --filter_domain D` : 도메인 필터링

## 요구사항

- Erlang 27.0
- Elixir main-otp-27

## 문서

문서는 [ExDoc](https://github.com/elixir-lang/ex_doc)로 생성할 수 있습니다:

```bash
mix docs
```

