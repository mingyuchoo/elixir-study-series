# README

## Structure

```
example_app
├── lib
│   └── example_app.ex
├── mix.exs
└── README.md
```

## Modify `*.ex{s}`

### example_app.ex

Change module `ExampleApp` to `ExampleApp.CLI`

### mix.exs

- Create `escript` function
- Update `project` function

## Build

```bash
$ mix escript.build
```

## Run

```bas
$ ./example_app --upcase Hello
HELLO

$ ./example_app Hi
Hi
```
