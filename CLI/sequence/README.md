# Sequence

## 개요

Sequence 애플리케이션은 숫자 시퀀스를 관리하는 OTP 27 기반 Elixir 애플리케이션입니다. 이 애플리케이션은 GenServer를 사용하여 상태를 관리하고, Supervisor를 통해 프로세스를 감독합니다.

## 사용 방법

### 설치 및 준비

```bash
# 모든 의존성 정리
mix deps.clean --all

# 의존성 다운로드
mix deps.get

# 의존성 컴파일
mix deps.compile
```

### 대화형 모드로 실행 (iex)

대화형 모드에서는 Elixir 셸을 통해 애플리케이션과 상호작용할 수 있습니다.

```bash
# 애플리케이션 시작과 함께 iex 실행
iex -S mix

# Sequence 모듈 함수 사용 (편의 함수)
iex> Sequence.next_number
# 현재 숫자를 반환하고 1 증가시킵니다

iex> Sequence.increment_number(100)
# 현재 숫자를 100만큼 증가시킵니다

# Server 모듈 직접 사용
iex> Sequence.Server.next_number
# 현재 숫자를 반환하고 1 증가시킵니다

iex> Sequence.Server.increment_number(100)
# 현재 숫자를 100만큼 증가시킵니다

# 종료하기
iex> C-c,C-c
```

### 명령행에서 직접 실행

명령행에서 직접 실행하면 대화형 모드 없이 애플리케이션을 실행할 수 있습니다.

```bash
# 기본 실행 - 기본 동작 수행
mix run -e Sequence.main

# 인자 전달 (숫자를 지정하여 증가시킴)
mix run -e "Sequence.main([\"50\"])"
# 50만큼 숫자를 증가시킵니다
```

### 릴리스 빌드 및 실행

OTP 27에서는 내장된 mix release 기능을 사용하여 배포 가능한 릴리스를 만들 수 있습니다.

```bash
# 릴리스 빌드
mix release

# 릴리스 실행
_build/dev/rel/sequence/bin/sequence start

# 릴리스 중지
_build/dev/rel/sequence/bin/sequence stop
```

## 주요 모듈

- `Sequence`: 메인 모듈, 애플리케이션 진입점 및 편의 함수 제공
- `Sequence.Server`: 시퀀스 숫자를 관리하는 GenServer
- `Sequence.Stash`: 상태를 유지하는 GenServer
- `Sequence.Application`: 애플리케이션 시작 및 수퍼바이저 설정
