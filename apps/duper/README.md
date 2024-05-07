# Duper

## How to run

```bash
time mix run --no-halt
```

## How to build for Release

```bash
mix deps.get --only prod
MIX_ENV=prod  # for fish, `set -x MIX_ENV prod`
mix compile
mix release
```
