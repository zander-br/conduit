defmodule Conduit.Auth.Guardian do
  @moduledoc """
  Used by Guardian to serialize a JWT token
  """

  use Guardian, otp_app: :conduit

  alias Conduit.Accounts
  alias Conduit.Accounts.Projections.User

  def subject_for_token(%User{id: id}, _claims), do: {:ok, id}
  def subject_for_token(_resource, _claims), do: {:error, "Unknown resource type"}

  def resource_from_claims(claims) do
    user =
      claims
      |> Map.get("sub")
      |> Accounts.user_by_uuid()

    {:ok, user}
  end
end
