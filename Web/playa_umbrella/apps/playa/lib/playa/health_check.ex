defmodule Playa.HealthCheck do
  import Ecto.Query, warn: false
  alias Playa.Accounts
  alias Playa.Accounts.Role

  @role_id 1
  def server_healthy? do
    case Accounts.get_role!(@role_id) do
      %Role{} -> true
      _ -> false
    end
  end
end
