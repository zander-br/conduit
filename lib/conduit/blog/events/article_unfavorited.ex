defmodule Conduit.Blog.Events.ArticleUnfavorited do
  @derive Jason.Encoder
  defstruct [:article_id, :unfavorited_by_author_id, :favorite_count]
end
