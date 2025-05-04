# RepoMonitor

이 애플리케이션은 Git 저장소를 모니터링하고 변경 사항이 감지되면 빌드 명령을 실행하는 Elixir OTP 27 호환 도구입니다.

## 기능

- Git 저장소 변경 사항 모니터링 (GitFetcher)
- 파일 시스템 변경 감지 (GitBuilder)
- 변경 시 자동 빌드 실행

## 필수 요구 사항

- Elixir ~> 1.16
- OTP 27
- Git
- inotify-tools (Linux 시스템용)

## 설치 방법

### 1. inotify-tools 설치 (Linux 시스템)

```bash
sudo apt install -y inotify-tools  # Ubuntu/Debian
# 또는
sudo yum install -y inotify-tools  # CentOS/RHEL
```

### 2. 환경 설정

```bash
cp .envrc_example .envrc
# .envrc 파일 편집
```

`.envrc` 파일에서 다음 환경 변수를 설정할 수 있습니다:

- `REPO_PATH`: 모니터링할 Git 저장소 경로 (기본값: ".")
- `BUILD_COMMAND`: 변경 감지 시 실행할 명령 (기본값: "mix run --no-halt")

## 빌드 및 실행

```bash
# 의존성 설치
mix deps.clean --all
mix deps.get
mix deps.compile

# 애플리케이션 실행
mix run --no-halt
```

## 작동 방식

1. `GitFetcher`는 5초마다 Git 저장소에서 변경 사항을 가져옵니다.
2. `GitBuilder`는 파일 시스템 변경을 감지하고 빌드 명령을 실행합니다.
3. 모든 변경 사항은 로그에 기록됩니다.

## OTP 27 호환성

이 애플리케이션은 OTP 27에 최적화되어 있으며 다음과 같은 현대적인 패턴을 사용합니다:

- 향상된 오류 처리 및 예외 관리
- 최신 구성 관리 기법
- 개선된 프로세스 통신
