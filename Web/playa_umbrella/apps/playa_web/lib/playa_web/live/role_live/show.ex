defmodule PlayaWeb.RoleLive.Show do
  use PlayaWeb, :live_view

  alias Playa.Accounts

  @impl true
  def mount(%{"role_id" => role_id}, _session, socket) do
    {:ok,
     socket
     |> stream(:users, Accounts.list_users_by_role_id(role_id))}
  end

  @impl true
  def handle_params(%{"role_id" => role_id}, _, socket) do
    {:noreply,
     socket
     |> assign(:page_title, page_title(socket.assigns.live_action))
     |> assign(:role, Accounts.get_role!(role_id))}
  end

  @impl true
  def handle_event("delete", %{"role_id" => role_id}, socket) do
    role = Accounts.get_role!(role_id)
    {:ok, _} = Accounts.delete_role(role)

    # 수정
    {:noreply, push_navigate(socket, to: "/accounts/roles")}
  end

  defp page_title(:show), do: "Show Role"
  defp page_title(:edit), do: "Edit Role"
end
