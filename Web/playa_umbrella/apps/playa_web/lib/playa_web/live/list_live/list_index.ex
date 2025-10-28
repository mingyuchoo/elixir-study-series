defmodule PlayaWeb.ListLive.ListIndex do
  alias Productivity.ActivityLog
  use PlayaWeb, :live_view

  alias Productivity.Works
  alias Productivity.Works.List

  @impl true
  def mount(_params, _session, socket) do
    {:ok, stream(socket, :lists, Works.list_lists())}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :list_edit, %{"list_id" => list_id}) do
    socket
    |> assign(:page_title, "Edit List")
    |> assign(:list, Works.get_list!(list_id))
  end

  defp apply_action(socket, :list_new, _params) do
    socket
    |> assign(:page_title, "New List")
    |> assign(:list, %List{})
  end

  defp apply_action(socket, :list_index, _params) do
    socket
    |> assign(:page_title, "My Lists")
    |> assign(:list, nil)
  end

  @impl true
  def handle_info({PlayaWeb.ListLive.ListFormComponent, {:saved, list}}, socket) do
    {:noreply, stream_insert(socket, :lists, list)}
  end

  @impl true
  def handle_event("delete", %{"list_id" => list_id}, socket) do
    {:ok, list} =
      Works.get_list!(list_id)
      |> Works.delete_list()

    ActivityLog.log(socket.assigns.scope, list, %{action: "delete"})

    {:noreply, stream_delete(socket, :lists, list)}
  end
end
