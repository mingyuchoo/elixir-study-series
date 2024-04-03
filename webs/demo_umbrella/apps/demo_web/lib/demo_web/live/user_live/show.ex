defmodule DemoWeb.UserLive.Show do
  use DemoWeb, :live_view

  alias Demo.Accounts

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  @impl true
  def handle_params(%{"id" => id}, _, socket) do
    {:noreply,
     socket
     |> assign(:page_title, page_title(socket.assigns.live_action))
     |> assign(:user, Accounts.get_user!(id))}
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    user = Accounts.get_user!(id)
    # NOTE:
    # User가 삭제될 때 Role에 user_count 1 차감
    Enum.map(user.roles, fn role ->
      case role.user_count > 0 do
        true -> Accounts.update_role(role, %{user_count: role.user_count - 1})
        false -> Accounts.update_role(role, %{user_count: 0})
      end
    end)

    {:ok, _} = Accounts.delete_user(user)

    {:noreply, push_navigate(socket, to: "/accounts/users")}
  end

  defp page_title(:show), do: "Show User"
  defp page_title(:edit), do: "Edit User"
end
