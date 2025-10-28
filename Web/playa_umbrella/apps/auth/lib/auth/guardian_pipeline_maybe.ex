defmodule Auth.GuardianPipelineMaybe do
  use Guardian.Plug.Pipeline,
    otp_app: :auth,
    module: Auth.Guardian,
    error_handler: Auth.GuardianErrorHandler

  plug(Guardian.Plug.VerifySession)
  plug(Guardian.Plug.VerifyHeader, realm: "Bearer")
  plug(Guardian.Plug.LoadResource, allow_blank: true)
end
