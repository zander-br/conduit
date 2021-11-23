defmodule Conduit.Blog.Projections.Article do
  use Ecto.Schema

  @primary_key {:id, :binary_id, autogenerate: false}

  schema "blog_articles" do
    field :slug, :string
    field :title, :string
    field :description, :string
    field :body, :string
    field :tag_list, {:array, :string}
    field :favorite_count, :integer, default: 0
    field :published_at, :utc_datetime_usec
    field :author_id, :binary_id
    field :author_bio, :string
    field :author_image, :string
    field :author_username, :string

    timestamps()
  end
end
