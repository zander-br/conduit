defmodule Conduit.Blog.Commands.FavoriteArticle do
  defstruct article_id: "", favorited_by_author_id: ""

  use ExConstructor
  use Vex.Struct

  validates(:article_id, uuid: true)
  validates(:favorited_by_author_id, uuid: true)
end
