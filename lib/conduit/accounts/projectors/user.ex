defmodule Conduit.Accounts.Projectors.User do
  use Commanded.Projections.Ecto,
    application: Conduit.App,
    repo: Conduit.Repo,
    name: "Accounts.Projectors.User"

  alias Conduit.Accounts.Events.UserRegistered
  alias Conduit.Accounts.Projections.User
  alias Ecto.Multi

  project(%UserRegistered{} = registered, fn multi ->
    Multi.insert(multi, :user, %User{
      uuid: registered.user_uuid,
      username: registered.username,
      email: registered.email,
      hashed_password: registered.hashed_password,
      bio: nil,
      image: nil
    })
  end)
end
