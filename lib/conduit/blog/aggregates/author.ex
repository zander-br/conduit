defmodule Conduit.Blog.Aggregates.Author do
  defstruct [:id, :user_id, :username, :bio, :image]

  alias Conduit.Blog.Aggregates.Author
  alias Conduit.Blog.Commands.CreateAuthor
  alias Conduit.Blog.Events.AuthorCreated

  @doc """
  Creates an author
  """
  def execute(%Author{id: nil}, %CreateAuthor{} = create) do
    %AuthorCreated{
      author_id: create.author_id,
      user_id: create.user_id,
      username: create.username
    }
  end

  def apply(%Author{} = author, %AuthorCreated{} = created) do
    %Author{
      author
      | id: created.author_id,
        user_id: created.user_id,
        username: created.username
    }
  end
end
