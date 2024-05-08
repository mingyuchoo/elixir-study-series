# LogRocket

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
