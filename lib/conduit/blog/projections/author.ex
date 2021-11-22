defmodule Conduit.Blog.Projections.Author do
  use Ecto.Schema

  @primary_key {:id, :binary_id, autogenerate: false}

  schema "blog_authors" do
    field :username, :string
    field :bio, :string
    field :image, :string
    field :user_uuid, :binary_id

    timestamps()
  end
end
