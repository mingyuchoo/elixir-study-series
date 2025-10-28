defmodule PlayaWeb.UserLive.Index do
  use PlayaWeb, :live_view

  alias Playa.Accounts
  alias Playa.Accounts.User

  @impl true
  def mount(_params, _session, socket) do
    {:ok, stream(socket, :users, Accounts.list_users())}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"user_id" => user_id}) do
    socket
    |> assign(:page_title, "Edit User")
    |> assign(:user, Accounts.get_user!(user_id))
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "New User")
    |> assign(:user, %User{})
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Listing Users")
    |> assign(:user, nil)
  end

  @impl true
  def handle_info({PlayaWeb.UserLive.FormComponent, {:saved, user}}, socket) do
    {:noreply, stream_insert(socket, :users, user)}
  end

  @impl true
  def handle_event("delete", %{"user_id" => user_id}, socket) do
    user = Accounts.get_user!(user_id)
    {:ok, _} = Accounts.delete_user(user)

    # NOTE:
    # User가 삭제될 때 Role에 user_count 1 차감
    Enum.map(user.roles, fn role -> Accounts.decrease_user_count(role) end)

    {:noreply, stream_delete(socket, :users, user)}
  end
end
