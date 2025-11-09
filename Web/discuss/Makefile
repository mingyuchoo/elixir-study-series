all: clean create migrate run
clean:
	mix clean
create:
	mix deps.get
	mix ecto.create
migrate:
	mix ecto.migrate
run:
	iex -S mix phx.server
release:
	docker build -t discuss:latest .
	docker run -it -e SECRET_KEY_BASE=$(mix phx.gen.secret) -p 80:4000 discuss:latest bash
