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

  def publish_article(%{author: author}) do
    {:ok, article} = fixture(:article, author: author)

    [article: article]
  end

  def publish_articles(%{author: author}) do
    {:ok, article1} =
      fixture(:article, author: author, tag_list: ["dragons", "training", "believe"])

    {:ok, article2} =
      fixture(:article,
        author: author,
        title: "How to train your dragon 2",
        description: "So toothless",
        body: "It a dragon"
      )

    [articles: [article1, article2]]
  end

  def fixture(resource, attrs \\ [])

  def fixture(:author, attrs) do
    build(:author, attrs) |> Blog.create_author()
  end

  def fixture(:user, attrs) do
    build(:user, attrs) |> Accounts.register_user()
  end

  def fixture(:article, attrs) do
    {author, attrs} = Keyword.pop(attrs, :author)

    Blog.publish_article(author, build(:article, attrs))
  end
end
