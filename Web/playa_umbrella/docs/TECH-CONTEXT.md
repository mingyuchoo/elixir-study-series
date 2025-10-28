# Context

## Ecto를 사용할 때

### 조회할 때 Ecto 사용

- <https://hexdocs.pm/ecto/Ecto.Query.html>

`Ecto.Qeury.*` 의 Expression 형태로 사용할 때

```elixir
List
|> select([l], l)
|> where([l], l.id == ^id)
|> order_by([l], asc: l.id)
|> preload([:user, :items])
|> Repo.all()
```

`Ecto.Qeury.preload/2` 를 사용할 때

1. from 사용
2. order_by 사용
3. preload 하고
4. 조회

`Repo.preload/2` 를 사용할 때

1. from 사용
2. order_by 사용
3. 조회
4. Repo.preload 하고

### 새로 생성할 때 Ecto 사용 순서

1. Changeset 적용
2. 생성 반영
3. Repo.preload 사용 <-- 화면 렌더링에 필요함

### 변경할 때 Ecto 사용 순서

1. Repo.preload 하고
2. Changeset 적용
3. 변경본 반영

### 삭제할 때 Ecto 사용 순서

1. Repo.preload 하고
2. 삭제 반영
