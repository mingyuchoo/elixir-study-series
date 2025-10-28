# Duper

Duper는 디렉터리 내 파일의 중복을 찾아내는 Elixir 기반 애플리케이션입니다.

## 프로젝트 구조

- `lib/duper.ex`: Duper의 메인 모듈입니다.
- `lib/duper/application.ex`: 애플리케이션의 엔트리포인트로, Supervisor 트리와 주요 프로세스들을 시작합니다.
- `lib/duper/path_finder.ex`: 디렉터리를 순회하며 다음 파일 경로를 제공합니다.
- `lib/duper/worker.ex`: 파일의 해시를 계산하여 중복 여부를 판단하는 워커 프로세스입니다.
- `lib/duper/worker_supervisor.ex`: 워커 프로세스를 동적으로 관리하는 Supervisor입니다.
- `lib/duper/result_gatherer.ex`: 워커의 결과를 모으고, 모든 작업이 끝나면 결과를 출력합니다.
- `lib/duper/result_storage.ex`: 파일 해시와 경로를 저장하고, 중복 파일 목록을 찾는 역할을 합니다.

## 주요 동작 방식

1. `Duper.Application`이 Supervisor 트리를 시작합니다.
2. `Duper.PathFinder`가 디렉터리를 순회하며 파일 경로를 제공합니다.
3. 여러 개의 `Duper.Worker`가 각 파일의 해시를 계산합니다.
4. 결과는 `Duper.ResultGatherer`로 전달되고, 해시와 경로는 `Duper.ResultStorage`에 저장됩니다.
5. 모든 작업이 끝나면 중복 파일 목록이 출력됩니다.

## How to build

```bash
mix deps.get
mix compile
```

## How to run

```bash
mix run
```

## How to build for Release

```bash
mix deps.get --only prod
MIX_ENV=prod  # for fish, `set -x MIX_ENV prod`
mix compile
mix release
```
