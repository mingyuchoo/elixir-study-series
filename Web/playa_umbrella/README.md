# Playa.Umbrella

## Dependency Diagram

```text
                   ┌──────────────┐                      
      ┌────────────┤     auth     ◄─────────────┐        
      │            └──────────────┘             │        
      │                                         │        
      │                                         │        
      │                                         │        
      │                                         │        
┌─────▼─────┐      ┌──────────────┐       ┌─────┴───────┐
│   playa   ◄──────┤ productivity ◄───────┤  playa_web  │
└───────────┘      └──────────────┘       └─────────────┘
```

## Apply database schema for new child project

For creation schema

```exs
...

  def up do
    execute "CREATE SCHEMA IF NOT EXISTS <schema_name>"
  end

  def down do
    execute "DROP SCHEMA IF EXISTS <schema_name>"
  end
```

For creation tables

```exs
...

  def change do
    create table(:<table_name>, prefix: :<schema_name>) do

      add :<column_name>, references(:lists, prefix: :productivity, on_delete: :nilify_all), null: true

      timestamps()
    end

    create index(:<table_name>, [:<column_name>], prefix: :<schema_name>)
```

For schema

```exs
...

  @schema_prefix :<schema_name>
  schema "<table_name>" do
    field :<column_name>, :<data_type>
  end
```

## How to compile and test

### Child Project

This compiles and tests a child project

```bash
$ cd playa_umbrella/apps/{new_child_project}
$ mix compile
$ mix test
```

### Playa Project

This compiles and tests all of child projects

```bash
$ cd playa_umbrella
$ mix compile
$ mix test
```

## How to build and run for Productional Release

```bash
$ cd playa_umbrella
$ direnv allow
$ make
$ make release
$ _build/prod/rel/playa_umbrella/bin/playa_umbrella start
```

## Login user

- `ghost@email.com` / `qwe123QWE!@#`

## References

- [Containerizing a Phoenix 1.6 Umbrella Project](https://medium.com/@alistairisrael/containerizing-a-phoenix-1-6-umbrella-project-8ec03651a59c)
- [AsciiFlow](https://asciiflow.com/)

