<p align="center">
  <a href="https://github.com/mingyuchoo/elixir-study-series/blob/main/LICENSE"><img alt="license" src="https://img.shields.io/github/license/mingyuchoo/elixir-study-series"/></a>
  <a href="https://github.com/mingyuchoo/elixir-study-series/issues"><img alt="Issues" src="https://img.shields.io/github/issues/mingyuchoo/elixir-study-series?color=appveyor" /></a>
  <a href="https://github.com/mingyuchoo/elixir-study-series/pulls"><img alt="GitHub pull requests" src="https://img.shields.io/github/issues-pr/mingyuchoo/elixir-study-series?color=appveyor" /></a>
</p>

# README

## How to install `Erlang`, `Elixir`, and `SBCL`

### Using `asdf` in Ubuntu

Please install ASDF from https://asdf-vm.com/guide/getting-started.html

```bash
sudo apt install -y libssl-dev automake autoconf libncurses-dev dirmngr gpg curl gawk libzstd-dev inotify-tools
# Donload and install `asdf` from https://github.com/asdf-vm/asdf/releases
asdf plugin add erlang https://github.com/asdf-vm/asdf-erlang.git
asdf plugin add elixir https://github.com/asdf-vm/asdf-elixir.git
asdf plugin add sbcl https://github.com/smashedtoatoms/asdf-sbcl.git
asdf install erlang latest 
asdf install elixir latest
asdf install sbcl latest
vim $HOME/.tool-versions
```

`$HOME/.tool-versions`

```bash
# $HOME/.tool-versions

erlang 27.3.4
elixir 1.18.3-otp-27
sbcl 2.5.4
```

Add `$HOME/.asdf/shims` to the front of your `$PATH`.

### NixOS

```bash
nix-env -iA erlang_27
nix-env -iA elixir_1_17
nix-env -iA inotify-tools
```

## Install Phoenix Framework

```bash
mix local.hex --force
mix archive.install hex phx_new
```

## Build for Release

```bash
export SECRET_KEY_BASE=$(mix phx.gen.secret)
export DATABASE_URL=ecto://{username}:{password}@{hostname}:{port}/{database-name}
mix deps.get --only prod
MIX_ENV=prod  # for fish, `set -x MIX_ENV prod`
mix compile
mix assets.deploy
mix phx.gen.release --docker
# change `bullseye-20240423-slim` to `buster-20240423-slim` in Dockerfile
# export or add in Dockerfile; SECRET_KEY_BASE=$(mix phx.gen.secret)
docker build -t myapp:latest .
docker run -it -e {ENV_VAR=VALUE} -p {extern-port}:{inner-port} {image}:{tag} bash
```
## Update outdated modules

```bash
mix hex.outdated
# update each version of modules in mix.exs file
mix hex.upgrade
mix deps.update --all
mix deps.get
mix compile
```

## Learn More

- <https://elixir-lang.org/install.html>
- <https://www.phoenixframework.org/>

