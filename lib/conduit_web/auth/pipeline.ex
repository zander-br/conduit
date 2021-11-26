defmodule ConduitWeb.Auth.Pipeline do
  use Guardian.Plug.Pipeline, otp_app: :conduit

  plug Guardian.Plug.VerifyHeader
  plug Guardian.Plug.LoadResource, allow_blank: true
end
