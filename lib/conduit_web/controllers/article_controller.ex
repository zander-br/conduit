defmodule ConduitWeb.ArticleController do
  use ConduitWeb, :controller

  alias Conduit.Blog
  alias Conduit.Blog.Projections.Article
  alias Guardian.Plug

  action_fallback ConduitWeb.FallbackController

  def create(conn, %{"article" => article_params}) do
    user = Plug.current_resource(conn)
    author = Blog.get_author!(user.id)

    with {:ok, %Article{} = article} <- Blog.publish_article(author, article_params) do
      conn
      |> put_status(:created)
      |> render("show.json", article: article)
    end
  end
end
