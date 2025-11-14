# README

## Types

- value types
  - integer:
  - float:
  - atom: `:atom`
    > Atom 은 이름이 곧 값인 상수, 다른 언어의 심볼(Symbol)과 비슷
    > - 같은 이름의 Atom은 메모리에서 같은 객체를 참조함
    > - 문자열보다 비교가 빠름
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
