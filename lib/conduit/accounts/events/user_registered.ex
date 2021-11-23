defmodule Conduit.Accounts.Events.UserRegistered do
  @derive Jason.Encoder
  defstruct [:user_id, :username, :email, :hashed_password]
end
