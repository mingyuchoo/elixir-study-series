# Discuss

Discuss는 Phoenix(버전 1.7.21) 기반의 Elixir 웹 애플리케이션입니다. PostgreSQL 데이터베이스를 사용하며, Tailwind와 esbuild로 프론트엔드 자산을 빌드합니다.

## 프로젝트 구조
- `lib/` : 주요 비즈니스 로직 및 웹 계층
- `assets/` : 프론트엔드 자산(Tailwind, JS 등)
- `config/` : 환경별 설정 파일
- `priv/` : 데이터베이스 마이그레이션, 정적 파일 등
- `test/` : 테스트 코드

## 주요 의존성
- phoenix ~> 1.7.21
- phoenix_ecto, ecto_sql, postgrex (PostgreSQL 연동)
- tailwind, esbuild (프론트엔드 빌드)
- 기타: swoosh, finch, telemetry, gettext 등

## 개발 및 실행 방법

### 1. 의존성 설치 및 초기화
```bash
mix setup
# 또는 아래 명령어를 순차적으로 실행
mix deps.clean --all
mix deps.get
mix ecto.setup
mix assets.setup
mix assets.build
```

### 2. 개발 서버 실행
```bash
mix phx.server
```

### 3. 테스트 실행
```bash
mix test
```

## 배포(Release) 및 Docker 빌드

### 1. 환경 변수 설정
```bash
export SECRET_KEY_BASE=$(mix phx.gen.secret)
export DATABASE_URL=ecto://{username}:{password}@{hostname}:{port}/{database-name}
```

### 2. 프로덕션 빌드
```bash
mix deps.get --only prod
MIX_ENV=prod mix compile
mix assets.deploy
mix phx.gen.release --docker
```

### 3. Docker 이미지 빌드 및 실행
- Dockerfile에서 `bullseye-20240423-slim`을 `buster-20240423-slim`으로 변경 필요할 수 있음
- SECRET_KEY_BASE를 Dockerfile에 직접 추가하거나 환경 변수로 전달

```bash
docker build -t discuss:latest .
docker run -it -e SECRET_KEY_BASE=$SECRET_KEY_BASE -e DATABASE_URL=$DATABASE_URL -p 4000:4000 discuss:latest
```

## 기타 참고 사항
- 자산 빌드: `mix assets.deploy` (Tailwind, esbuild, phx.digest)
- 데이터베이스 마이그레이션/시드: `mix ecto.migrate`, `mix run priv/repo/seeds.exs`
- 자세한 설정은 `mix.exs` 및 `config/` 디렉토리 참고
