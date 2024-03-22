defmodule HelloWeb.HealthCheckController do
  use HelloWeb, :controller

  def index(conn, _params) do
    HelloApp.HealthCheck.server_healthy?
    |> get_server_health
    |> send_health_response conn
  end

  defp get_server_health(true), do: :healthy
  defp get_server_health(false), do: :unhealthy

  defp send_health_response(status, conn) do
    conn
    |> json %{status: status,
             timestamp: DateTime.utc_now |> DateTime.to_iso8601,
             version: Mix.Project.config()[:version]
             }
  end
end
