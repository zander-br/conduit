defmodule Conduit.Blog.Queries.ListArticles do
  import Ecto.Query

  alias Conduit.Blog.Projections.Article

  defmodule Options do
    defstruct limit: 20, offset: 0, author: nil, tag: nil

    use ExConstructor
  end

  def paginate(params, repo) do
    options = Options.new(params)

    articles = query(options) |> entries(options) |> repo.all()
    total_count = query(options) |> count() |> repo.aggregate(:count, :id)

    {articles, total_count}
  end

  defp query(options) do
    from(a in Article)
    |> filter_by_author(options)
    |> filter_by_tag(options)
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

  defp entries(query, %Options{limit: limit, offset: offset}) do
    query
    |> order_by([a], desc: a.published_at)
    |> limit(^limit)
    |> offset(^offset)
  end

  defp count(query) do
    query |> select([:id])
  end
end
