defmodule PlayaWeb.CounterLive.Index do
  use PlayaWeb, :live_view

  @doc """
  params: URL parameters
  session: cookies, sessions...
  """
  @impl true
  def mount(_params, _session, socket) do
    {:ok,
     socket
     |> assign(count: 0)}
  end

  @impl true
  def handle_event("increment", _params, socket) do
    {:noreply, update(socket, :count, &(&1 + 1))}
  end

  @impl true
  def handle_event("decrement", _params, socket) do
    {:noreply, update(socket, :count, &(&1 - 1))}
  end

  @impl true
  def handle_event("update", %{"value" => value}, socket) do
    case NumberConverter.to_integer(value) do
      {:ok, value} -> {:noreply, socket |> assign(count: value)}
      {:error, _} -> {:noreply, socket}
    end
  end
end

defmodule NumberConverter do
  @moduledoc """
  입력된 문자열을 Integer 또는 Float 형태로 변환합니다.
  """
  def to_integer(str) when is_binary(str) do
    case Integer.parse(str) do
      {num, ""} -> {:ok, num}
      _ -> {:error, :not_a_number}
    end
  end

  def to_float(str) when is_binary(str) do
    case Float.parse(str) do
      {num, ""} -> {:ok, num}
      _ -> {:error, :not_a_number}
    end
  end
end
