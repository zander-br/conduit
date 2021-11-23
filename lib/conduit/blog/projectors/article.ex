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
      id: author.author_id,
      user_id: author.user_id,
      username: author.username,
      bio: nil,
      image: nil
    })
  end)

  project(%ArticlePublished{} = published, %{created_at: published_at}, fn multi ->
    multi
    |> Ecto.Multi.run(:author, fn _repo, _changes -> get_author(published.author_id) end)
    |> Ecto.Multi.run(:article, fn _repo, %{author: author} ->
      article = %Article{
        id: published.article_id,
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

  defp get_author(id) do
    case Repo.get(Author, id) do
      nil -> {:error, :author_not_found}
      author -> {:ok, author}
    end
  end
end
