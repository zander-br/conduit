defmodule ConduitWeb.Router do
  use ConduitWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  pipeline :auth do
    plug ConduitWeb.Auth.Pipeline
  end

  scope "/api", ConduitWeb do
    pipe_through [:api, :auth]

    get "/users", UserController, :current
  end

  scope "/api", ConduitWeb do
    pipe_through :api

    post "/users/login", SessionController, :create
    post "/users", UserController, :create
  end
end
