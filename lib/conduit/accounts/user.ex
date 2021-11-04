defmodule Conduit.Accounts.User do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "accounts_users" do
    field :bio, :string
    field :email, :string
    field :hashed_password, :string
    field :image, :string
    field :username, :string

    timestamps()
  end

  @doc false
  def changeset(user, attrs) do
    user
    |> cast(attrs, [:username, :email, :hashed_password, :bio, :image])
    |> validate_required([:username, :email, :hashed_password, :bio, :image])
  end
end
