defmodule Conduit.Auth do
  @moduledoc """
  Authentication using the bcrypt password hashing function.
  """

  def hash_password(password) do
    %{password_hash: password_hash} = Bcrypt.add_hash(password)
    password_hash
  end

  def validate_password(password, hash), do: Bcrypt.verify_pass(password, hash)
end
