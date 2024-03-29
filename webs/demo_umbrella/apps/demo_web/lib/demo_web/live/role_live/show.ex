defmodule DemoWeb.RoleLive.Show do
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
     |> assign(:role, Accounts.get_role!(id))}
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    role = Accounts.get_role!(id)
    {:ok, _} = Accounts.delete_role(role)

    # 수정
    {:noreply, push_navigate(socket, to: "/roles")}
  end

  defp page_title(:show), do: "Show Role"
  defp page_title(:edit), do: "Edit Role"
end
