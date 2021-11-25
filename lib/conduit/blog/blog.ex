defmodule Conduit.Blog do
  @moduledoc """
  The bondary for the Blog system.
  """

  import Ecto.Query, warn: false

  alias Conduit.App, as: ConduitApp
  alias Conduit.Blog.Commands.{CreateAuthor, PublishArticle}
  alias Conduit.Blog.Projections.{Article, Author}
  alias Conduit.Blog.Queries.{ArticleBySlug, ListArticles}
  alias Conduit.{Repo, Router}

  @doc """
  Get the author for a given id, or raise an `Ecto.NoResultsError` if not found.
  """
  def get_author!(id), do: Repo.get!(Author, id)

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
  @spec list_articles(params :: map()) ::
          {articles :: list(Article.t()), article_count :: non_neg_integer()}
  def list_articles(params \\ %{}) do
    ListArticles.paginate(params, Repo)
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
