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

    get "/user", UserController, :current

    post "/articles", ArticleController, :create
  end

  scope "/api", ConduitWeb do
    pipe_through :api

    get "/articles", ArticleController, :index
    get "/articles/:slug", ArticleController, :show

    post "/users/login", SessionController, :create
    post "/users", UserController, :create
  end
end
