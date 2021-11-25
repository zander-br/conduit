defmodule Conduit.Repo.Migrations.AddIndexToBlogTags do
  use Ecto.Migration

  def change do
    create index(:blog_articles, [:tag_list], usign: "GIN")
  end
end
