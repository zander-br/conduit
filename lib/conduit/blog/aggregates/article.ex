defmodule Conduit.Blog.Aggregates.Article do
  defstruct id: nil,
            slug: nil,
            title: nil,
            description: nil,
            body: nil,
            tag_list: nil,
            author_id: nil,
            favorited_by_authors: MapSet.new(),
            favorite_count: 0

  alias Conduit.Blog.Aggregates.Article
  alias Conduit.Blog.Commands.{FavoriteArticle, PublishArticle, UnfavoriteArticle}
  alias Conduit.Blog.Events.{ArticleFavorited, ArticlePublished, ArticleUnfavorited}

  # Publish an article
  def execute(%Article{id: nil}, %PublishArticle{} = publish) do
    %ArticlePublished{
      article_id: publish.article_id,
      slug: publish.slug,
      title: publish.title,
      description: publish.description,
      body: publish.body,
      tag_list: publish.tag_list,
      author_id: publish.author_id
    }
  end

  # Favorite the article for an author
  def execute(%Article{id: nil}, %FavoriteArticle{}), do: {:error, :article_not_found}

  def execute(
        %Article{id: id, favorite_count: favorite_count} = article,
        %FavoriteArticle{favorited_by_author_id: author_id}
      ) do
    case is_favorited?(article, author_id) do
      true ->
        nil

      false ->
        %ArticleFavorited{
          article_id: id,
          favorited_by_author_id: author_id,
          favorite_count: favorite_count + 1
        }
    end
  end

  # Unfavorite the article for the user
  def execute(%Article{id: nil}, %UnfavoriteArticle{}), do: {:error, :article_not_found}

  def execute(
        %Article{id: id, favorite_count: favorite_count} = article,
        %UnfavoriteArticle{unfavorited_by_author_id: author_id}
      ) do
    case is_favorited?(article, author_id) do
      true ->
        %ArticleUnfavorited{
          article_id: id,
          unfavorited_by_author_id: author_id,
          favorite_count: favorite_count - 1
        }

      false ->
        nil
    end
  end

  # state mutators

  def apply(%Article{} = article, %ArticlePublished{} = published) do
    %Article{
      article
      | id: published.article_id,
        slug: published.slug,
        title: published.title,
        description: published.description,
        body: published.body,
        tag_list: published.tag_list,
        author_id: published.author_id
    }
  end

  def apply(
        %Article{favorited_by_authors: favorited_by} = article,
        %ArticleFavorited{favorited_by_author_id: author_id, favorite_count: favorite_count}
      ) do
    %Article{
      article
      | favorited_by_authors: MapSet.put(favorited_by, author_id),
        favorite_count: favorite_count
    }
  end

  def apply(
        %Article{favorited_by_authors: favorited_by} = article,
        %ArticleUnfavorited{unfavorited_by_author_id: author_id, favorite_count: favorite_count}
      ) do
    %Article{
      article
      | favorited_by_authors: MapSet.delete(favorited_by, author_id),
        favorite_count: favorite_count
    }
  end

  # Is the article a favorite of the user?
  defp is_favorited?(%Article{favorited_by_authors: favorited_by}, user_id) do
    MapSet.member?(favorited_by, user_id)
  end
end
