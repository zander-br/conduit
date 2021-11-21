defmodule ConduitWeb.SessionController do
  use ConduitWeb, :controller

  alias Conduit.Accounts.Projections.User
  alias Conduit.Auth
  alias ConduitWeb.{UserView, ValidationView}

  action_fallback ConduitWeb.FallbackController

  def create(conn, %{"user" => %{"email" => email, "password" => password}}) do
    with {:ok, %User{} = user} <- Auth.authenticate(email, password),
         {:ok, jwt} <- generate_jwt(user) do
      conn
      |> put_status(:created)
      |> put_view(UserView)
      |> render("show.json", user: user, jwt: jwt)
    else
      {:error, :unauthenticated} ->
        conn
        |> put_status(:unprocessable_entity)
        |> put_view(ValidationView)
        |> render("error.json", errors: %{"email or password" => ["is invalid"]})
    end
  end
end
