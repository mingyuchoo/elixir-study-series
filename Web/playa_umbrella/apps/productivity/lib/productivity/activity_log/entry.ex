defmodule Productivity.EctoTypes.Stringable do
  use Ecto.Type

  @impl Ecto.Type
  def load(value), do: {:ok, value}

  @impl Ecto.Type
  def type, do: :string

  @impl Ecto.Type
  def cast(val) when is_atom(val), do: {:ok, Atom.to_string(val)}
  def cast(val) when is_binary(val), do: {:ok, val}
  def cast(val) when is_integer(val) or is_float(val), do: {:ok, to_string(val)}
  def cast(_), do: :error

  @impl Ecto.Type
  def dump(value) when is_binary(value) do
    {:ok, value}
  end

  def dump(_), do: :error
end

defmodule Productivity.ActivityLog.Entry do
  use Ecto.Schema
  import Ecto.Changeset

  alias Playa.Accounts.User
  alias Productivity.Works.{Item, List}

  @schema_prefix :productivity
  schema "entries" do
    field :action, :string

    belongs_to :user, User
    belongs_to :list, List
    belongs_to :item, Item

    timestamps()
  end

  @doc false
  def changeset(entry, attrs) do
    entry
    |> cast(attrs, [:action])
    |> validate_required([:action])
  end
end
