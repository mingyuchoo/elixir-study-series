all: clean create migrate run
clean:
	mix clean
create:
	mix ecto.create
migrate:
	mix ecto.migrate
run:
	iex -S mix phx.server
release:
	docker build -t my_app:latest .
	docker run -it -e SECRET_KEY_BASE=$(mix phx.gen.secret) -p 80:4000 my_app:latest bash
