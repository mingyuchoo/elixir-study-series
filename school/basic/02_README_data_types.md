# README

## Types

- value types
  - integer:
  - float:
  - atom: `:atom`
  - range: `..`
  - regular expression: `~r{regular_expressions}`
- system types
  - process ID: `pid()`
  - port: `self()`
  - reference: `make_ref()`
- collection types
  - tuples: `{,}`
  - lists: `[]`
    - keywowrd lists: `[keyword: value]`
- map: `%{key => value, key => value}`
- binary: `<<integer,integer,...>>`
- date and time: `~D[...]`, `~T[...]`, `Date`, `Time`
- boolean: `true`, `false`, `nil`

## Atoms

- `atom` is a *literal* used as the name of a *constant*
- Just like as `symbole` in LISP
