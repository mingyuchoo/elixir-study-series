# Cards

## How to compile

```bash
mix deps.clean --all
mix deps.get
mix deps.compile
```

## How to run

### 1. CLI로 직접 실행

```bash
mix run -- 5
```

- 위 명령어는 5장의 카드를 뽑아 출력합니다.
- 사용법: `mix run -- <hand_size>`
- 예시 출력:

```
{"손패 리스트", "남은 카드 리스트"}

예)
{"[\"Seven of Diamonds\", ...]", "[\"Eight of Hearts\", ...]"}
```

### 2. iex에서 함수 직접 실행

```bash
iex -S mix
iex> Cards.create_hand(3)
```

---

프로젝트 구조:
```
apps/cards
├── lib/
│   └── cards.ex      # Cards 모듈 및 main 함수
├── mix.exs           # 프로젝트 설정
├── README.md         # 사용법 안내
```

## How to generate docs

```bash
mix docs
```
