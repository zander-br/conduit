defmodule Conduit.Fixture do
  import Conduit.Factory

  alias Conduit.Accounts
  alias Conduit.Blog

  def register_user(_context) do
    {:ok, user} = fixture(:user)

    [user: user]
  end

  def create_author(_context) do
    {:ok, author} = fixture(:author, user_id: UUID.uuid4())

    [author: author]
  end

  def fixture(resource, attrs \\ [])

  def fixture(:author, attrs) do
    build(:author, attrs) |> Blog.create_author()
  end

  def fixture(:user, attrs) do
    build(:user, attrs) |> Accounts.register_user()
  end
end
