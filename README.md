<p align="center">
  <a href="https://github.com/mingyuchoo/elixir-study-series/blob/main/LICENSE"><img alt="license" src="https://img.shields.io/github/license/mingyuchoo/elixir-study-series"/></a>
  <a href="https://github.com/mingyuchoo/elixir-study-series/issues"><img alt="Issues" src="https://img.shields.io/github/issues/mingyuchoo/elixir-study-series?color=appveyor" /></a>
  <a href="https://github.com/mingyuchoo/elixir-study-series/pulls"><img alt="GitHub pull requests" src="https://img.shields.io/github/issues-pr/mingyuchoo/elixir-study-series?color=appveyor" /></a>
</p>

# README

## Install Elixir

### NixOS

```bash
nix-env -iA erlang_26
nix-env -iA elixir_1_16
nix-env -iA inotify-tools
```

## Learn More

- <https://elixir-lang.org/install.html>
- <https://www.phoenixframework.org/>

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
