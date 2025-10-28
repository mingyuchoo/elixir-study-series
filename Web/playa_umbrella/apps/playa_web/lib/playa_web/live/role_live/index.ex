defmodule PlayaWeb.RoleLive.Index do
  use PlayaWeb, :live_view

  alias Playa.Accounts
  alias Playa.Accounts.Role

  @impl true
  def mount(_params, _session, socket) do
    {:ok, stream(socket, :roles, Accounts.list_roles())}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"role_id" => role_id}) do
    socket
    |> assign(:page_title, "Edit Role")
    |> assign(:role, Accounts.get_role!(role_id))
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "New Role")
    |> assign(:role, %Role{})
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Listing Roles")
    |> assign(:role, nil)
  end

  @impl true
  def handle_info({PlayaWeb.RoleLive.FormComponent, {:saved, role}}, socket) do
    {:noreply, stream_insert(socket, :roles, role)}
  end

  @impl true
  def handle_event("delete", %{"role_id" => role_id}, socket) do
    role = Accounts.get_role!(role_id)
    {:ok, _} = Accounts.delete_role(role)

    {:noreply, stream_delete(socket, :roles, role)}
  end
end
