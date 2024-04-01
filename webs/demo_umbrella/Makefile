all: clean drop create migrate run

clean:
	mix clean
drop:
	mix ecto.drop
create:
	mix ecto.create
migrate:
	mix ecto.migrate
run:
	iex -S mix phx.server
