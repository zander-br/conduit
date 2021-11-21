defmodule ConduitWeb.Router do
  use ConduitWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  pipeline :auth do
    plug Guardian.Plug.Pipeline,
      error_handler: ConduitWeb.ErrorHandler,
      module: Conduit.Auth.Guardian

    plug Guardian.Plug.VerifyHeader, scheme: "Token"
    plug Guardian.Plug.LoadResource
  end

  scope "/api", ConduitWeb do
    pipe_through :api

    post "/users/login", SessionController, :create
    post "/users", UserController, :create
  end
end
