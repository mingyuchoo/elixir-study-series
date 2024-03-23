defmodule HelloWeb.HealthCheckController do
  use HelloWeb, :controller

  defmodule HealthResponse do
    @derive Jason.Encoder
    defstruct [:status, :timestamp, :version]
  end

  def index(conn, _params) do
    HelloApp.HealthCheck.server_healthy?()
    |> convert_to_status
    |> send_response(conn)
  end

  defp convert_to_status(true), do: :healthy
  defp convert_to_status(false), do: :unhealthy

  defp send_response(status, conn) do
    health_response = %HealthResponse{
      status: status,
      timestamp: DateTime.utc_now() |> DateTime.to_iso8601(),
      version: Mix.Project.config()[:version] || "unknown"
    }

    json(conn, health_response)
  end
end
