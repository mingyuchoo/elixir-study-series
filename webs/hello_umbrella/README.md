# Hello.Umbrella

## Set this up

```bash
$ mix deps.get
$ mix phx.server
# or
$ iex -S mix phx.server
```

## Database

### Start up PostgreSQL

You can start up container with:

```bash
# start up
docker compose --file docker-compose.yml up --build --detach
```

You can check the database in the docker container

```bash
# get into the database
docker exec --user root --interactive --tty postgresql-db /bin/bash
# psql -U postgres -W
> \?
```

## APIs

### Health Check

#### API information

- uri: `/api/health-check`
- verb: `GET`
- request: N/A
- response: `{status:, timestamp:, version:}`

#### Module information

- base-path: `hello_umbrella/apps/hello_web`
- files:
  - `lib/hello_web/router.ex`
  - `lib/hello_web/controllers/health_check.ex`
