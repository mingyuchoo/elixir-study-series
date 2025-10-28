defmodule Productivity.Works do
  @moduledoc """
  The Works context.
  """

  import Ecto.Query, warn: false
  alias Productivity.Repo

  alias Productivity.Works.List

  @doc """
  Returns the list of lists.

  ## Examples

      iex> list_lists()
      [%List{}, ...]

  """
  def list_lists() do
    List
    |> select([l], l)
    |> order_by([l], asc: l.id)
    |> preload([:user, :items])
    |> Repo.all()
  end

  @doc """
  Gets a single list.

  Raises `Ecto.NoResultsError` if the List does not exist.

  ## Examples

      iex> get_list!(123)
      %List{}

      iex> get_list!(456)
      ** (Ecto.NoResultsError)

  """
  def get_list!(id) do
    List
    |> select([l], l)
    |> where([l], l.id == ^id)
    |> preload([:user, :items])
    |> Repo.one!()
  end

  @doc """
  Creates a list.
  ## Examples

      iex> create_list(%{field: value})
      {:ok, %List{}}

      iex> create_list(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_list(attrs \\ %{}) do
    %List{}
    |> List.changeset(attrs)
    |> Repo.insert()
    # IMPORTANT:
    # 리스트를 생성한 뒤 preload 하지 않으면
    # 연관된 데이터가 없어 목록을 화면에 표현할 때
    # 오류가 발생할 수 있음
    |> case do
      {:ok, list} -> {:ok, Repo.preload(list, [:user, :items])}
      {:error, changeset} -> {:error, changeset}
    end
  end

  @doc """
  Updates a list.

  ## Examples

      iex> update_list(list, %{field: new_value})
      {:ok, %List{}}

      iex> update_list(list, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_list(%List{} = list, attrs) do
    list
    |> Repo.preload([:user, :items])
    |> List.changeset(attrs)
    |> Repo.update()
  end

  def increase_item_count(%List{} = list) do
    list
    # NOTE: 모든 연관 관계를 preload 함
    |> Repo.preload([:user, :items])
    |> List.changeset(%{item_count: list.item_count + 1})
    |> Repo.update()
  end

  def decrease_item_count(%List{} = list) do
    new_item_count = max(list.item_count - 1, 0)

    list
    # NOTE: 모든 연관 관계를 preload 함
    |> Repo.preload([:user, :items])
    |> List.changeset(%{item_count: new_item_count})
    |> Repo.update()
  end

  @doc """
  Deletes a list.

  ## Examples

      iex> delete_list(list)
      {:ok, %List{}}

      iex> delete_list(list)
      {:error, %Ecto.Changeset{}}

  """
  def delete_list(%List{} = list) do
    list
    |> Repo.preload([:user, :items])
    |> Repo.delete()
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking list changes.

  ## Examples

      iex> change_list(list)
      %Ecto.Changeset{data: %List{}}

  """
  def change_list(%List{} = list, attrs \\ %{}) do
    list
    # NOTE: 모든 연관 관계를 preload 함
    |> Repo.preload([:user, :items])
    |> List.changeset(attrs)
  end

  # ---------------------------------------------------------------------

  alias Productivity.Works.Item

  @doc """
  Returns the list of items.

  ## Examples

      iex> list_items()
      [%Item{}, ...]

  """
  def list_items do
    Item
    |> select([i], i)
    |> order_by([i], asc: i.id)
    |> preload([:user, :list])
    |> Repo.all()
  end

  def list_items_by_list_id(list_id) do
    Item
    |> select([i], i)
    |> where([i], i.list_id == ^list_id)
    |> order_by([i], asc: i.id)
    |> preload([:user, :list])
    |> Repo.all()
  end

  @doc """
  Gets a single item.

  Raises `Ecto.NoResultsError` if the Item does not exist.

  ## Examples

      iex> get_item!(123)
      %Item{}

      iex> get_item!(456)
      ** (Ecto.NoResultsError)

  """
  def get_item!(id) do
    Item
    |> select([i], i)
    |> where([i], i.id == ^id)
    |> preload([:user, :list])
    |> Repo.one!()
  end

  @doc """
  Creates a item.
  NOTE:
  아이템을 생성한 뒤 preload 하지 않으면 목록을 보여줄 때
  item.list 데이터가 없어 목록을 생성할 또 오류 발생함
  ## Examples

      iex> create_item(%{field: value})
      {:ok, %Item{}}

      iex> create_item(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_item(attrs \\ %{}) do
    %Item{}
    |> Item.changeset(attrs)
    |> Repo.insert()
    # IMPORTANT:
    # 리스트를 생성한 뒤 preload 하지 않으면
    # 연관된 데이터가 없어 목록을 화면에 표현할 때
    # 오류가 발생할 수 있음
    |> case do
      {:ok, item} -> {:ok, Repo.preload(item, [:user, :list])}
      {:error, changeset} -> {:error, changeset}
    end
  end

  @doc """
  Updates a item.

  ## Examples

      iex> update_item(item, %{field: new_value})
      {:ok, %Item{}}

      iex> update_item(item, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_item(%Item{} = item, attrs) do
    item
    |> Repo.preload([:user, :list])
    |> Item.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a item.

  ## Examples

      iex> delete_item(item)
      {:ok, %Item{}}

      iex> delete_item(item)
      {:error, %Ecto.Changeset{}}

  """
  def delete_item(%Item{} = item) do
    item
    |> Repo.preload([:user, :list])
    |> Repo.delete()
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking item changes.

  ## Examples

      iex> change_item(item)
      %Ecto.Changeset{data: %Item{}}

  """
  def change_item(%Item{} = item, attrs \\ %{}) do
    Item.changeset(item, attrs)
  end
end
