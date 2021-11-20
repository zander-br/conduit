defmodule ConduitWeb.FallbackController do
  use ConduitWeb, :controller

  alias ConduitWeb.{ErrorView, ValidationView}

  def call(conn, {:error, :validation_failure, errors}) do
    conn
    |> put_status(:unprocessable_entity)
    |> put_view(ValidationView)
    |> render("error.json", errors: errors)
  end

  def call(conn, {:error, :not_found}) do
    conn
    |> put_status(:not_found)
    |> put_view(ErrorView)
    |> render(:"404")
  end
end
