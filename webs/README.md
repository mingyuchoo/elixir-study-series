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

## Install Inotify-tools

As you change your views or your assets, it automatically reloads the page in the browser.

### NixOS

```bash
$ nix-env -i inotify-tools
```

## Create new Phoenix project

```bash
$ mix phx.new <project_name>
$ cd <project_name>
```

## Configure database

Configure your database in config/dev.exs and run:

```bash
$ mix ecto.create
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

## References

- <https://hexdocs.pm/phoenix/installation.html>
