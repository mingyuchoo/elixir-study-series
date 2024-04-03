defmodule DemoWeb.ListLive.Index do
  use DemoWeb, :live_view

  alias Demo.Todos
  alias Demo.Todos.List

  @impl true
  def mount(_params, _session, socket) do
    {:ok, stream(socket, :lists, Todos.list_lists())}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, "Edit List")
    |> assign(:list, Todos.get_list!(id))
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "New List")
    |> assign(:list, %List{})
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Listing Lists")
    |> assign(:list, nil)
  end

  @impl true
  def handle_info({DemoWeb.ListLive.FormComponent, {:saved, list}}, socket) do
    {:noreply, stream_insert(socket, :lists, list)}
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    list = Todos.get_list!(id)
    {:ok, _} = Todos.delete_list(list)

    {:noreply, stream_delete(socket, :lists, list)}
  end
end
