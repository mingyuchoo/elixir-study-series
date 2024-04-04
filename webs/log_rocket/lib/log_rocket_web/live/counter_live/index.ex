defmodule LogRocketWeb.CounterLive.Index do
  use LogRocketWeb, :live_view

  @impl true
  def mount(_params, _session, socket) do
    {:ok, assign(socket, count: 0)}
  end

  @impl true
  def handle_event("inc", _params, socket) do
    {:noreply, assign(socket, count: socket.assigns.count(+1))}
  end

  @impl true
  def render(assigns) do
    ~H"""
    <div>
      <h1>Counter</h1>
      <p>Count: <%= @count %></p>
      <button phx-disable-with="Sending..." phx-click="inc">Increment</button>
    </div>
    """
  end
end
