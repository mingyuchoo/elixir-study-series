# REAME

## How to install Elixir

- <https://elixir-lang.org/install.html>

## How to trying Interactive Mode

Enter `iex` in the terminal

```bash
$ iex
iex(1)>
```
Try out some expressions

```elixir
iex> 2+3
5
iex> 2+3 == 5
true
iex> String.length("The quick brown fox jumpbs over the lazy dog")
43
```

### How to compile a file in IEx

```bash
iex(1)> c "hello.exs"
Hello, World!
[]
```

### How to use IEx.Helpers

```bash
$ iex
iex(1)> h
```

- iex> h(ModuleName)                                     # help message
- iex> h(ModuleName.FunctionName)                        # help message
- iex> h(ModuleName.FunctionName/NumberOfArguments)      # help message
- iex> c(FileName.FileExtension)                         # compile a file
- iex> i(ValueToIntrospect)                              # introspect
- iex> exports(ModuleName)                               # export module
