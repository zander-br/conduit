defmodule ConduitWeb.JWT do
  @moduledoc """
  JSON Web Token helper functions, using Guardian
  """

  alias Conduit.Auth.Guardian

  def generate_jwt(resource) do
    case Guardian.encode_and_sign(resource) do
      {:ok, jwt, _claims} -> {:ok, jwt}
    end
  end
end
