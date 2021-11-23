defmodule Conduit.Repo.Migrations.CreateBlogAuthors do
  use Ecto.Migration

  def change do
    create table(:blog_authors, primary_key: false) do
      add :id, :uuid, primary_key: true
      add :user_id, :uuid
      add :username, :string
      add :bio, :string
      add :image, :string

      timestamps()
    end

    create unique_index(:blog_authors, [:user_id])
  end
end
