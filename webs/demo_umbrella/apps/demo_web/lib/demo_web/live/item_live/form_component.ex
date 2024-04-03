defmodule DemoWeb.ItemLive.FormComponent do
  use DemoWeb, :live_component

  alias Demo.Todos

  @impl true
  def render(assigns) do
    ~H"""
    <div>
      <.header>
        <%= @title %>
        <:subtitle>Use this form to manage item records in your database.</:subtitle>
      </.header>

      <.simple_form
        for={@form}
        id="item-form"
        phx-target={@myself}
        phx-change="validate"
        phx-submit="save"
      >
        <!--
        리스트 셀렉트박스 추가
          - prompt 를 넣으면 기본 선택 안 됨
        -->
        <.input
          field={@form[:list_id]}
          type="select"
          label="Lists"
          prompt="No list selected"
          options={Enum.map(@lists, &{&1.title, &1.id})}
        />
        <.input field={@form[:title]} type="text" label="Title" placeholder="New item title" />
        <:actions>
          <.button phx-disable-with="Saving...">Save Item</.button>
        </:actions>
      </.simple_form>
    </div>
    """
  end

  @doc """
  데이터를 컴포넌트에 전달하는데 사용
  """
  @impl true
  def update(%{item: item} = assigns, socket) do
    changeset = Todos.change_item(item)
    # 모든 리스트를 가져옴
    lists = Todos.list_lists()

    {:ok,
     socket
     |> assign(assigns)
     # 리스트 데이터를 소켓에 할당
     |> assign(:lists, lists)
     |> assign_form(changeset)}
  end

  @impl true
  def handle_event("validate", %{"item" => item_params}, socket) do
    changeset =
      socket.assigns.item
      |> Todos.change_item(item_params)
      |> Map.put(:action, :validate)

    {:noreply, assign_form(socket, changeset)}
  end

  def handle_event("save", %{"item" => item_params}, socket) do
    save_item(socket, socket.assigns.action, item_params)
  end

  defp save_item(socket, :edit, item_params) do
    case Todos.update_item(socket.assigns.item, item_params) do
      {:ok, item} ->
        notify_parent({:saved, item})

        {:noreply,
         socket
         |> put_flash(:info, "Item updated successfully")
         |> push_patch(to: socket.assigns.patch)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign_form(socket, changeset)}
    end
  end

  defp save_item(socket, :new, item_params) do
    case Todos.create_item(item_params) do
      {:ok, item} ->
        notify_parent({:saved, item})

        {:noreply,
         socket
         |> put_flash(:info, "Item created successfully")
         |> push_patch(to: socket.assigns.patch)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign_form(socket, changeset)}
    end
  end

  defp assign_form(socket, %Ecto.Changeset{} = changeset) do
    assign(socket, :form, to_form(changeset))
  end

  defp notify_parent(msg), do: send(self(), {__MODULE__, msg})
end
