defmodule Conduit.Blog.Projectors.Article do
  use Commanded.Projections.Ecto,
    application: Conduit.App,
    repo: Conduit.Repo,
    name: "Blog.Projectors.Article",
    consistency: :strong

  alias Conduit.Blog.Events.{ArticlePublished, AuthorCreated}
  alias Conduit.Blog.Projections.{Article, Author}
  alias Conduit.Repo
  alias Ecto.Multi

  project(%AuthorCreated{} = author, fn multi ->
    Multi.insert(multi, :author, %Author{
      id: author.author_uuid,
      user_id: author.user_uuid,
      username: author.username,
      bio: nil,
      image: nil
    })
  end)

  project(%ArticlePublished{} = published, %{created_at: published_at}, fn multi ->
    multi
    |> Ecto.Multi.run(:author, fn _repo, _changes -> get_author(published.author_uuid) end)
    |> Ecto.Multi.run(:article, fn _repo, %{author: author} ->
      article = %Article{
        id: published.article_uuid,
        slug: published.slug,
        title: published.title,
        description: published.description,
        body: published.body,
        tag_list: published.tag_list,
        favorite_count: 0,
        published_at: published_at,
        author_id: author.id,
        author_username: author.username,
        author_bio: author.bio,
        author_image: author.image
      }

      Repo.insert(article)
    end)
  end)

  defp get_author(uuid) do
    case Repo.get(Author, uuid) do
      nil -> {:error, :author_not_found}
      author -> {:ok, author}
    end
  end
end
