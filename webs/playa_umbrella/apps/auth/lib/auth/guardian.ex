defmodule Auth.Guardian do
  use Guardian, otp_app: :auth

  alias Playa.Accounts

  def issue_access_token(resource) do
    claims = %{"typ" => "access", "aud" => "Auth", "exp" => Guardian.timestamp() + 60}
    Guardian.encode_and_sign(__MODULE__, resource, claims)
  end

  def issue_refresh_token(resource) do
    claims = %{"typ" => "refresh", "aud" => "Auth", "exp" => Guardian.timestamp() + 24 * 60 * 60}
    Guardian.encode_and_sign(__MODULE__, resource, claims)
  end

  def encode_and_sign_with_ttl(resource, ttl \\ 60) do
    claims = %{"exp" => Guardian.timestamp() + ttl}
    Guardian.encode_and_sign(__MODULE__, resource, claims)
  end

  def subject_for_token(user, _claims) do
    {:ok, to_string(user.id)}
  end

  def resource_from_claims(%{"sub" => id}) do
    user = Accounts.get_user!(id)
    {:ok, user}
  rescue
    Ecto.NoResultsError -> {:error, :resource_not_found}
  end

  def resource_from_claims(_claims) do
    {:error, :resource_not_found}
  end
end
