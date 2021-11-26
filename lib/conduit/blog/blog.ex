defmodule Conduit.Blog do
  @moduledoc """
  The bondary for the Blog system.
  """

  import Ecto.Query, warn: false

  alias Conduit.Accounts.Projections.User
  alias Conduit.App, as: ConduitApp
  alias Conduit.Blog.Commands.{CreateAuthor, FavoriteArticle, PublishArticle, UnfavoriteArticle}
  alias Conduit.Blog.Projections.{Article, Author}
  alias Conduit.Blog.Queries.{ArticleBySlug, ListArticles}
  alias Conduit.{Repo, Router}

  @doc """
  Get the author for a given id, or raise an `Ecto.NoResultsError` if not found.
  """
  def get_author!(id), do: Repo.get!(Author, id)

  @doc """
  Get the author for a given id, or nil if the user is nil
  """
  def get_author(user)
  def get_author(nil), do: nil
  def get_author(%User{id: user_id}), do: get_author(user_id)
  def get_author(id) when is_bitstring(id), do: Repo.get(Author, id)

  @doc """
  Get an article by its URL slug, or return `nil` if not found.
  """
  def article_by_slug(slug), do: article_by_slug_query(slug) |> Repo.one()

  @doc """
  Get an article by its URL slug, or raise an `Ecto.NoResultsError` if not found
  """
  def article_by_slug!(slug), do: article_by_slug_query(slug) |> Repo.one!()

  @doc """
  Create an author.
  An author shares the same id as the user, but with a different prefix.
  """
  def create_author(%{user_id: id} = attrs) do
    create_author =
      attrs
      |> CreateAuthor.new()
      |> CreateAuthor.assign_id(id)

    with :ok <- Router.dispatch(create_author, application: ConduitApp, consistency: :strong) do
      get(Author, id)
    else
      reply -> reply
    end
  end

  @doc """
  Publishes an article by the given author.
  """
  def publish_article(%Author{} = author, attrs \\ %{}) do
    id = UUID.uuid4()

    publish_article =
      attrs
      |> PublishArticle.new()
      |> PublishArticle.assign_id(id)
      |> PublishArticle.assign_author(author)
      |> PublishArticle.generate_url_slug()

    with :ok <- Router.dispatch(publish_article, application: ConduitApp, consistency: :strong) do
      get(Article, id)
    else
      reply -> reply
    end
  end

  @doc """
  Returns most recent articles globally by default.

  Provide tag, author or favorited query parameter to filter results.
  """
  @spec list_articles(params :: map(), author :: Author.t()) ::
          {articles :: list(Article.t()), article_count :: non_neg_integer()}
  def list_articles(params \\ %{}, author \\ nil)

  def list_articles(params, author) do
    ListArticles.paginate(params, author, Repo)
  end

  @doc """
  Favorite the article for an author
  """
  def favorite_article(%Article{id: article_id}, %Author{id: author_id}) do
    favorite_article = %FavoriteArticle{
      article_id: article_id,
      favorited_by_author_id: author_id
    }

    with :ok <- Router.dispatch(favorite_article, application: ConduitApp, consistency: :strong),
         {:ok, article} <- get(Article, article_id) do
      {:ok, %Article{article | favorited: true}}
    else
      reply -> reply
    end
  end

  @doc """
  Unfavorite the article for an author
  """
  def unfavorite_article(%Article{id: article_id}, %Author{id: author_id}) do
    unfavorite_article = %UnfavoriteArticle{
      article_id: article_id,
      unfavorited_by_author_id: author_id
    }

    with :ok <-
           Router.dispatch(unfavorite_article, application: ConduitApp, consistency: :strong),
         {:ok, article} <- get(Article, article_id) do
      {:ok, %Article{article | favorited: false}}
    else
      reply -> reply
    end
  end

  defp get(schema, id) do
    case Repo.get(schema, id) do
      nil -> {:error, :not_found}
      projection -> {:ok, projection}
    end
  end

  defp article_by_slug_query(slug) do
    slug
    |> String.downcase()
    |> ArticleBySlug.new()
  end
end
