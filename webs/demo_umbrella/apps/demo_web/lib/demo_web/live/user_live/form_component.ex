defmodule DemoWeb.UserLive.FormComponent do
  use DemoWeb, :live_component

  alias Demo.Accounts
  alias Demo.Accounts.User

  @impl true
  def render(assigns) do
    ~H"""
    <div>
      <.header>
        <%= @title %>
        <:subtitle>Use this form to manage user records in your database.</:subtitle>
      </.header>

      <.simple_form
        for={@form}
        id="user-form"
        phx-target={@myself}
        phx-change="validate"
        phx-submit="save"
      >
        <.input field={@form[:email]} type="text" label="Email" />
        <.input field={@form[:password]} type="password" label="Password" />
        <.input field={@form[:nickname]} type="text" label="Nickname" />
        <!-- 추가 -->
        <.input
          field={@form[:role_id]}
          type="select"
          label="Role"
          prompt="Select a role"
          options={Enum.map(@roles, &{&1.name, &1.id})}
        />
        <:actions>
          <.button phx-disable-with="Saving...">Save User</.button>
        </:actions>
      </.simple_form>
    </div>
    """
  end

  @impl true
  def update(%{user: user} = assigns, socket) do
    changeset = Accounts.change_user(user)

    {:ok,
     socket
     |> assign(assigns)
     |> assign_form(changeset)}
  end

  @impl true
  def handle_event("validate", %{"user" => user_params}, socket) do
    changeset = Accounts.change_user_registration(%User{}, user_params)
    {:noreply, assign_form(socket, Map.put(changeset, :action, :validate))}
  end

  @impl true
  def handle_event("save", %{"user" => user_params}, socket) do
    save_user(socket, socket.assigns.action, user_params)
  end

  defp save_user(socket, :edit, user_params) do
    case Accounts.update_user(socket.assigns.user, user_params) do
      {:ok, user} ->
        notify_parent({:saved, user})

        {:noreply,
         socket
         |> put_flash(:info, "User updated successfully")
         |> push_patch(to: socket.assigns.patch)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign_form(socket, changeset)}
    end
  end

  defp save_user(socket, :new, user_params) do
    case Accounts.create_user(user_params) do
      {:ok, user} ->
        notify_parent({:saved, user})

        # 추가
        role = Accounts.get_role!(user.role_id)
        Accounts.update_role(role, %{user_count: role.user_count + 1})

        {:ok, _} =
          Accounts.deliver_user_confirmation_instructions(user, &url(~p"/users/confirm/#{&1}"))

        # changeset = Accounts.change_user_registration(user)

        {:noreply,
         socket
         |> assign(trigger_submit: true)
         |> put_flash(:info, "User created successfully")
         |> push_patch(to: socket.assigns.patch)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, socket |> assign(check_errors: true) |> assign_form(changeset)}
    end
  end

  defp assign_form(socket, %Ecto.Changeset{} = changeset) do
    # 추가
    socket
    |> assign(:form, to_form(changeset))
    |> assign(:roles, Accounts.list_roles())
  end

  defp notify_parent(msg), do: send(self(), {__MODULE__, msg})
end
