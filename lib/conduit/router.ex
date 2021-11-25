defmodule Conduit.Router do
  use Commanded.Commands.Router

  alias Conduit.Accounts.Aggregates.User
  alias Conduit.Accounts.Commands.RegisterUser
  alias Conduit.Blog.Aggregates.{Article, Author}
  alias Conduit.Blog.Commands.{CreateAuthor, FavoriteArticle, PublishArticle, UnfavoriteArticle}
  alias Conduit.Support.Middleware.{Uniqueness, Validate}

  middleware(Validate)
  middleware(Uniqueness)

  identify(Article, by: :article_id, prefix: "article-")
  identify(Author, by: :author_id, prefix: "author-")
  identify(User, by: :user_id, prefix: "user-")

  dispatch([CreateAuthor], to: Author)
  dispatch([PublishArticle, FavoriteArticle, UnfavoriteArticle], to: Article)
  dispatch([RegisterUser], to: User)
end
