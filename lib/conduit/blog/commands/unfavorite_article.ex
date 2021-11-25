defmodule Conduit.Blog.Commands.UnfavoriteArticle do
  defstruct article_id: "", unfavorited_by_author_id: ""

  use ExConstructor
  use Vex.Struct

  validates(:article_id, uuid: true)
  validates(:unfavorited_by_author_id, uuid: true)
end
