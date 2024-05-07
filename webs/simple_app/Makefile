all: clean create migrate run
clean:
	mix clean
create:
	mix ecto.create
migrate:
	mix ecto.migrate
run:
	iex -S mix phx.server
