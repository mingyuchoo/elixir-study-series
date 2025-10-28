defmodule PlayaWeb.ListLive.ListShow do
  alias Productivity.ActivityLog
  use PlayaWeb, :live_view

  alias Productivity.Works
  alias Productivity.Works.Item

  @impl true
  def mount(%{"list_id" => list_id}, _session, socket) do
    {:ok,
     socket
     |> stream(:items, Works.list_items_by_list_id(list_id))}
  end

  @impl true
  def handle_params(%{"list_id" => list_id} = params, _url, socket) do
    {:noreply,
     socket
     |> assign(:page_title, page_title(socket.assigns.live_action))
     |> assign(:list, Works.get_list!(list_id))
     |> apply_action(socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :list_show, _params),
    do: socket

  defp apply_action(socket, :list_edit, _params),
    do: socket

  defp apply_action(socket, :item_new, _params),
    do:
      socket
      |> assign(:page_title, "New Item")
      |> assign(:item, %Item{})

  defp apply_action(socket, :item_edit, %{"item_id" => item_id}),
    do:
      socket
      |> assign(:page_title, "Edit Item")
      |> assign(:item, Works.get_item!(item_id))

  @impl true
  def handle_info({PlayaWeb.ListLive.ListFormComponent, {:saved, _list}}, socket) do
    {:noreply, socket}
  end

  @impl true
  def handle_info({PlayaWeb.ListLive.ItemFormComponent, {:saved, item}}, socket) do
    {:noreply, stream_insert(socket, :items, item)}
  end

  @impl true
  def handle_event("delete:list_delete", %{"list_id" => list_id}, socket) do
    {:ok, list} = Works.get_list!(list_id) |> Works.delete_list()
    ActivityLog.log(socket.assigns.scope, list, %{action: "delete:list_delete"})
    # NOTE:
    # 상세 화면에서 데이터를 삭제하면 현재 화면에서는 보여줄 데이터가 없어서
    # 목록 화면으로 이동시켜야 함
    {:noreply, redirect(socket, to: "/works/lists")}
  end

  @impl true
  def handle_event("delete:item_delete", %{"item_id" => item_id}, socket) do
    {:ok, item} = Works.get_item!(item_id) |> Works.delete_item()

    ActivityLog.log(socket.assigns.scope, item, %{action: "delete:item_delete"})

    item.list_id
    |> Works.get_list!()
    |> Works.decrease_item_count()

    {:noreply, stream_delete(socket, :items, item)}
  end

  defp page_title(:list_show), do: "Show List"
  defp page_title(:list_edit), do: "Edit List"
  defp page_title(:item_new), do: "New Item"
  defp page_title(:item_edit), do: "Edit Item"
end
