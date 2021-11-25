defmodule Conduit.Blog.Events.ArticleFavorited do
  @derive Jason.Encoder
  defstruct [:article_id, :favorited_by_author_id, :favorite_count]
end
