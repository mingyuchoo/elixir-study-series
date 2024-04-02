all: clean drop create migrate seed run

clean:
	mix clean
drop:
	mix ecto.drop
create:
	mix ecto.create
migrate:
	mix ecto.migrate
seed:
	mix run apps/demo/priv/repo/seeds.exs
run:
	iex -S mix phx.server
