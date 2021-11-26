defmodule Conduit.Blog.Queries.ListArticles do
  import Ecto.Query

  alias Conduit.Blog.Projections.{Article, Author, FavoritedArticle}

  defmodule Options do
    defstruct limit: 20, offset: 0, author: nil, tag: nil, favorited: nil

    use ExConstructor
  end

  def paginate(params, author, repo) do
    options = Options.new(params)
    query = query(options)

    articles = query |> entries(options, author) |> repo.all()
    total_count = query |> count() |> repo.aggregate(:count, :id)

    {articles, total_count}
  end

  defp query(options) do
    from(a in Article)
    |> filter_by_author(options)
    |> filter_by_tag(options)
    |> filter_by_favorited_by_user(options)
  end

  defp filter_by_author(query, %Options{author: nil}), do: query

  defp filter_by_author(query, %Options{author: author}) do
    query |> where(author_username: ^author)
  end

  defp filter_by_tag(query, %Options{tag: nil}), do: query

  defp filter_by_tag(query, %Options{tag: tag}) do
    from a in query,
      where: fragment("? @> ?", a.tag_list, [^tag])
  end

  defp filter_by_favorited_by_user(query, %Options{favorited: nil}), do: query

  defp filter_by_favorited_by_user(query, %Options{favorited: favorited}) do
    from a in query,
      join: f in FavoritedArticle,
      on: [article_id: a.id, favorited_by_username: ^favorited]
  end

  defp entries(query, %Options{limit: limit, offset: offset}, author) do
    query
    |> include_favorited_by_author(author)
    |> order_by([a], desc: a.published_at)
    |> limit(^limit)
    |> offset(^offset)
  end

  defp count(query) do
    query |> select([:id])
  end

  defp include_favorited_by_author(query, nil), do: query

  defp include_favorited_by_author(query, %Author{id: author_id}) do
    from(a in query,
      left_join: f in FavoritedArticle,
      on: [article_id: a.id, favorited_by_author_id: ^author_id],
      select: %{a | favorited: not is_nil(f.article_id)}
    )
  end
end
