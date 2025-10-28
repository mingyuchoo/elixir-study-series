# Create Project

## How to create umbrella project as RESTful API server

```bash
$ mix phx.new playa --umbrella --no-assets --no-html --no-live --no-tailwind --no-esbuild
$ cd playa_umbrella/apps/playa_web
$ mix phx.gen.json Accounts User users nickname:string
$ mix phx.gen.json Accounts Role roles name:string
$ mix phx.gen.json Accounts RoleUser roles_users
$ mix phx.gen.json Accounts UserToken users_tokens
$ cd ../
$ mix phx.new.ecto productivity
```

## 자식 프로젝트 만들기

### 프로젝트 생성하기

```bash
$ cd playa_umbrella
$ cd apps
$ mix phx.new.ecto {new_child_project}
```

### 데이터베이스 스키마 설정하기

```elixir file=/config/dev.exs
# Configure your database
config :{new_child_project}, <NewChildProject>.Repo,
  username: "postgres",
  password: "postgres",
  hostname: System.get_env("DATABASE_HOST") || "localhost",
  database: "{database-name}",   # 변경 부분
  schema: "{new_child_project}", # 추가 부분
  stacktrace: true,
  show_sensitive_data_on_connection_error: true,
  pool_size: 10
```

```elixir file=/config/test.exs
config :{new_child_project}, <NewChildProject>.Repo,
  username: "postgres",
  password: "postgres",
  hostname: System.get_env("DATABASE_HOST") || "localhost",
  database: "{database-name}#{System.get_env("MIX_TEST_PARTITION")}", # 변경 부분
  schema: "{new_child_project}",                                      # 추가 부분
  pool: Ecto.Adapters.SQL.Sandbox,
  pool_size: System.schedulers_online() * 2

```