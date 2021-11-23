defmodule Conduit.Blog.Aggregates.Article do
  defstruct [:id, :slug, :title, :description, :body, :tag_list, :author_id]

  alias Conduit.Blog.Aggregates.Article
  alias Conduit.Blog.Commands.PublishArticle
  alias Conduit.Blog.Events.ArticlePublished

  @doc """
  Publish an article
  """
  def execute(%Article{id: nil}, %PublishArticle{} = publish) do
    %ArticlePublished{
      article_id: publish.article_id,
      slug: publish.slug,
      title: publish.title,
      description: publish.description,
      body: publish.body,
      tag_list: publish.tag_list,
      author_id: publish.author_id
    }
  end

  # state mutators

  def apply(%Article{} = article, %ArticlePublished{} = published) do
    %Article{
      article
      | id: published.article_id,
        slug: published.slug,
        title: published.title,
        description: published.description,
        body: published.body,
        tag_list: published.tag_list,
        author_id: published.author_id
    }
  end
end
