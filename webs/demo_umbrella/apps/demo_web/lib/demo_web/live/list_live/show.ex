defmodule DemoWeb.ListLive.Show do
  use DemoWeb, :live_view

  alias Demo.Todos

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  @impl true
  def handle_params(%{"id" => id}, _, socket) do
    {:noreply,
     socket
     |> assign(:page_title, page_title(socket.assigns.live_action))
     |> assign(:list, Todos.get_list!(id))}
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    list = Todos.get_list!(id)
    {:ok, _} = Todos.delete_list(list)
    # NOTE:
    # 상세 화면에서 데이터를 삭제하면 현재 화면에서는 보여줄 데이터가 없어서
    # 목록 화면으로 이동시켜야 함
    {:noreply, redirect(socket, to: "/todos/lists")}
  end

  defp page_title(:show), do: "Show List"
  defp page_title(:edit), do: "Edit List"
end
