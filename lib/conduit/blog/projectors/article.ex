defmodule Conduit.Blog.Projectors.Article do
  use Commanded.Projections.Ecto,
    application: Conduit.App,
    repo: Conduit.Repo,
    name: "Blog.Projectors.Article",
    consistency: :strong

  alias Conduit.Blog.Events.{
    ArticleFavorited,
    ArticlePublished,
    ArticleUnfavorited,
    AuthorCreated
  }

  alias Conduit.Blog.Projections.{Article, Author, FavoritedArticle}
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
    |> Multi.run(:author, fn _repo, _changes -> get_author(published.author_id) end)
    |> Multi.run(:article, fn _repo, %{author: author} ->
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

  project(
    %ArticleFavorited{
      article_id: article_id,
      favorited_by_author_id: favorited_by_author_id,
      favorite_count: favorite_count
    },
    fn multi ->
      multi
      |> Multi.insert(:favorited_article, %FavoritedArticle{
        article_id: article_id,
        favorited_by_author_id: favorited_by_author_id
      })
      |> Multi.update_all(:article, article_query(article_id),
        set: [favorite_count: favorite_count]
      )
    end
  )

  project(
    %ArticleUnfavorited{
      article_id: article_id,
      unfavorited_by_author_id: unfavorited_by_author_id,
      favorite_count: favorite_count
    },
    fn multi ->
      multi
      |> Multi.delete_all(
        :favorited_article,
        favorited_article_query(article_id, unfavorited_by_author_id)
      )
      |> Multi.update_all(:article, article_query(article_id),
        set: [favorite_count: favorite_count]
      )
    end
  )

  defp article_query(article_id) do
    from(a in Article, where: a.id == ^article_id)
  end

  defp favorited_article_query(article_id, author_id) do
    from(f in FavoritedArticle,
      where: f.article_id == ^article_id and f.favorited_by_author_id == ^author_id
    )
  end

  defp get_author(id) do
    case Repo.get(Author, id) do
      nil -> {:error, :author_not_found}
      author -> {:ok, author}
    end
  end
end
