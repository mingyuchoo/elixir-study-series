# README

## Install Hex package manager

Hex is necessary to get a Phoenix app running and to install any extra dependencies we might need along the way.

```bash
$ mix local.hex
```

## Install Phoenix application generator

```bash
$ mix archive.install hex phx_new
```

## Install PostgreSQL

Please use  https://github.com/mingyuchoo/docker-composes/tree/main/postgresql


## Install Inotify-tools

As you change your views or your assets, it automatically reloads the page in the browser.

### NixOS

```bash
$ nix-env -i inotify-tools
```

## Create new Phoenix project

Create full featured project

```bash
$ mix phx.new <project_name>
$ cd <project_name>
```

Create umbrella project

```bash
$ mix phx.new <project_name> --umbrella
$ cd <project_name>
```

Create essential featured project. this would be fit to JSON API server

```bash
$ mix phx.new <project_name> --umbrella --no-html --no-assets --no-esbuild --no-tailwind --no-dashboard --no-ecto --no-gettext --no-live --no-mailer
$ cd <project_name>
```

### Install dependencies

```bash
$ mix deps.get
```

## Configure database

Configure your database in config/dev.exs and run:

```bash
$ mix ecto.create
```

You can drop the database configured:

```bash
$ mix ecto.drop
```


## Start application

Start your Phoenix app with:

```bash
$ mix phx.server
```

You can also run your app inside IEx (Interactive Elixir) as:

```bash
$ iex -S mix phx.server
```

## Build for Release

```bash
export SECRET_KEY_BASE=$(mix phx.gen.secret)
export DATABASE_URL=ecto://<username>:<password>@<hostname>:<port>/<datbase_name>
mix deps.get --only prod
MIX_ENV=prod  # for fish, `set -x MIX_ENV prod`
mix compile
mix assets.deploy
mix phx.gen.release --docker
# change `bullseye-20240423-slim` to `buster-20240423-slim` in Dockerfile
# export or add in Dockerfile; SECRET_KEY_BASE=$(mix phx.gen.secret)
docker build -t myapp:latest .
docker run -it -e <ENV_VAR=VALUE> -p <extern_port>:<inner_port> <image>:<tag> bash
```

## References

- <https://hexdocs.pm/phoenix/installation.html>
- <https://blog.logrocket.com/build-rest-api-elixir-phoenix/>
