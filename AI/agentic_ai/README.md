# Agentic AI Assistant

Elixir/Phoenix 기반의 Agentic AI 어시스턴트 애플리케이션입니다.
Azure OpenAI API (gpt-5-mini)를 사용하여 도구 호출 기능이 있는 대화형 AI를 구현합니다.

## 기술 스택

- **언어**: Elixir 1.19+
- **웹 프레임워크**: Phoenix 1.8+ (LiveView)
- **데이터베이스**: SQLite3 (Ecto)
- **AI**: Azure OpenAI API (gpt-5-mini)
- **프로젝트 구조**: Umbrella

## 프로젝트 구조

```
agentic_ai/
├── apps/
│   ├── core/                 # 핵심 비즈니스 로직
│   │   ├── lib/core/
│   │   │   ├── agent/        # AI 에이전트 (ReAct 패턴)
│   │   │   │   ├── supervisor.ex
│   │   │   │   ├── worker.ex
│   │   │   │   ├── tool_registry.ex
│   │   │   │   └── tools/    # 도구 구현
│   │   │   │       ├── calculator.ex
│   │   │   │       ├── date_time.ex
│   │   │   │       ├── web_search.ex
│   │   │   │       ├── file_system.ex
│   │   │   │       └── code_executor.ex
│   │   │   ├── llm/          # LLM 클라이언트
│   │   │   │   └── azure_openai.ex
│   │   │   ├── schema/       # Ecto 스키마
│   │   │   │   ├── conversation.ex
│   │   │   │   ├── message.ex
│   │   │   │   └── tool.ex
│   │   │   └── repo.ex
│   │   └── priv/repo/migrations/
│   │
│   └── web/                  # Phoenix 웹 앱
│       └── lib/web_web/
│           ├── live/
│           │   └── chat_live.ex
│           └── router.ex
│
├── config/
│   ├── config.exs
│   ├── dev.exs
│   ├── prod.exs
│   ├── test.exs
│   └── runtime.exs
│
└── mix.exs
```

## 에이전트 도구

| 도구 | 설명 |
|------|------|
| `get_current_time` | 현재 시간 조회 (타임존 지원) |
| `calculate` | 수학 계산 |
| `search_web` | 웹 검색 (DuckDuckGo) |
| `read_file` | 파일 읽기 |
| `write_file` | 파일 쓰기 |
| `list_directory` | 디렉터리 목록 |
| `execute_code` | Elixir 코드 실행 |

## 설치 및 실행

### 1. 환경 변수 설정

```bash
export AZURE_OPENAI_ENDPOINT="https://your-resource.openai.azure.com"
export AZURE_OPENAI_API_KEY="your-api-key"
```

### 2. 의존성 설치

```bash
cd agentic_ai
mix deps.get
```

### 3. 데이터베이스 설정

```bash
mix ecto.create
mix ecto.migrate
```

### 4. 서버 실행

```bash
mix phx.server
```

브라우저에서 <http://localhost:4000/chat> 접속

## 개발

### IEx 셸에서 실행

```bash
iex -S mix phx.server
```

### 테스트

```bash
mix test
```

## ReAct 패턴

이 에이전트는 ReAct (Reasoning + Acting) 패턴을 구현합니다:

1. **Reasoning**: LLM이 상황을 분석하고 다음 행동을 결정
2. **Acting**: 필요한 도구를 호출하여 작업 수행
3. **Observation**: 도구 실행 결과를 관찰
4. **반복**: 목표 달성까지 1-3단계 반복

## 라이선스

MIT

---

Made with 💥 by 붐돌이
