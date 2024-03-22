defmodule HelloWeb.HealthCheckController do
  use HelloWeb, :controller

  def index(conn, _params) do
    if server_healthy?() do
      send_health_response(conn, :healthy)
    else
      send_health_response(conn, :unhealthy)
    end
  end

  defp server_healthy? do
    # check databases and external services related with
    true
  end

  defp send_health_response(conn, status) do
    timestamp = DateTime.utc_now() |> DateTime.to_iso8601()
    version = Mix.Project.config()[:version]
    json(conn, %{ status: status, timestamp: timestamp, version: version })
  end
end
