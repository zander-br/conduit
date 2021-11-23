defmodule Conduit.Accounts.Projectors.User do
  use Commanded.Projections.Ecto,
    application: Conduit.App,
    repo: Conduit.Repo,
    name: "Accounts.Projectors.User",
    consistency: :strong

  alias Conduit.Accounts.Events.UserRegistered
  alias Conduit.Accounts.Projections.User
  alias Ecto.Multi

  project(%UserRegistered{} = registered, fn multi ->
    Multi.insert(multi, :user, %User{
      id: registered.user_id,
      username: registered.username,
      email: registered.email,
      hashed_password: registered.hashed_password,
      bio: nil,
      image: nil
    })
  end)
end
