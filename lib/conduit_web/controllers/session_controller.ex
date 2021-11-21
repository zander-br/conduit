defmodule ConduitWeb.SessionController do
  use ConduitWeb, :controller

  alias Conduit.Accounts.Projections.User
  alias Conduit.Auth
  alias ConduitWeb.{UserView, ValidationView}

  action_fallback ConduitWeb.FallbackController

  def create(conn, %{"user" => %{"email" => email, "password" => password}}) do
    case Auth.authenticate(email, password) do
      {:ok, %User{} = user} ->
        conn
        |> put_status(:created)
        |> put_view(UserView)
        |> render("show.json", user: user)

      {:error, :unauthenticated} ->
        conn
        |> put_status(:unprocessable_entity)
        |> put_view(ValidationView)
        |> render("error.json", errors: %{"email or password" => ["is invalid"]})
    end
  end
end
