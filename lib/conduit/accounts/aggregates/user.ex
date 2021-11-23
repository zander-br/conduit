defmodule Conduit.Accounts.Aggregates.User do
  defstruct [:id, :username, :email, :hashed_password]

  alias Conduit.Accounts.Aggregates.User
  alias Conduit.Accounts.Commands.RegisterUser
  alias Conduit.Accounts.Events.UserRegistered

  @doc """
    Register a new user
  """

  def execute(%User{id: nil}, %RegisterUser{} = register) do
    %UserRegistered{
      user_id: register.user_id,
      username: register.username,
      email: register.email,
      hashed_password: register.hashed_password
    }
  end

  def apply(%User{} = user, %UserRegistered{} = registered) do
    %User{
      user
      | id: registered.user_id,
        username: registered.username,
        email: registered.email,
        hashed_password: registered.hashed_password
    }
  end
end
