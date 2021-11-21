defmodule Conduit.Fixture do
  import Conduit.Factory

  alias Conduit.Accounts

  def fixture(:user, attrs \\ []) do
    build(:user, attrs) |> Accounts.register_user()
  end

  def register_user(_context) do
    {:ok, user} = fixture(:user)

    [user: user]
  end
end
