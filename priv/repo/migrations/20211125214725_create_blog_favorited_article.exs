defmodule Conduit.Repo.Migrations.CreateBlogFavoritedArticle do
  use Ecto.Migration

  def change do
    create table(:blog_favorited_articles, primary_key: false) do
      add :article_id, :uuid, primary_key: true
      add :favorited_by_author_id, :uuid, primary_key: true

      timestamps()
    end
  end
end
