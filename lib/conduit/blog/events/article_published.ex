defmodule Conduit.Blog.Events.ArticlePublished do
  @derive Jason.Encoder
  defstruct [:article_id, :author_id, :slug, :title, :description, :body, :tag_list]
end
