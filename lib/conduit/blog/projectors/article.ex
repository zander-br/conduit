defmodule Conduit.Blog.Projectors.Article do
  use Commanded.Projections.Ecto,
    application: Conduit.App,
    repo: Conduit.Repo,
    name: "Blog.Projectors.Article",
    consistency: :strong

  alias Conduit.Blog.Events.AuthorCreated
  alias Conduit.Blog.Projections.Author
  alias Ecto.Multi

  project(%AuthorCreated{} = author, fn multi ->
    Multi.insert(multi, :author, %Author{
      id: author.author_uuid,
      user_uuid: author.user_uuid,
      username: author.username,
      bio: nil,
      image: nil
    })
  end)
end
