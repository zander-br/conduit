defmodule Conduit.Blog.Commands.PublishArticle do
  defstruct article_id: "",
            author_id: "",
            slug: "",
            title: "",
            description: "",
            body: "",
            tag_list: []

  use ExConstructor
  use Vex.Struct

  alias Conduit.Blog.Commands.PublishArticle
  alias Conduit.Blog.Projections.Author
  alias Conduit.Blog.Slugger

  validates(:article_id, uuid: true)

  validates(:author_id, uuid: true)

  validates(:slug,
    presence: [message: "can't be empty"],
    format: [with: ~r/^[a-z0-9\-]+$/, allow_nil: true, allow_blank: true, message: "is invalid"],
    string: true,
    unique_article_slug: true
  )

  validates(:title, presence: [message: "can't be empty"], string: true)

  validates(:description, presence: [message: "can't be empty"], string: true)

  validates(:body, presence: [message: "can't be empty"], string: true)

  validates(:tag_list, by: &is_list/1)

  @doc """
  Assign a unique identity
  """
  def assign_id(%PublishArticle{} = publish_article, id) do
    %PublishArticle{publish_article | article_id: id}
  end

  @doc """
  Assign the author
  """
  def assign_author(%PublishArticle{} = publish_article, %Author{id: id}) do
    %PublishArticle{publish_article | author_id: id}
  end

  @doc """
  Generate a unique URL slug from the article title
  """
  def generate_url_slug(%PublishArticle{title: title} = publish_article) do
    case Slugger.slugify(title) do
      {:ok, slug} -> %PublishArticle{publish_article | slug: slug}
      _ -> publish_article
    end
  end

  defimpl Conduit.Support.Middleware.Uniqueness.UniqueFields,
    for: Conduit.Blog.Commands.PublishArticle do
    def unique(_command),
      do: [
        {:slug, "has already been taken"}
      ]
  end
end
