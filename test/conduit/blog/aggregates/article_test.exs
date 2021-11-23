defmodule Conduit.Blog.Aggregates.ArticleTest do
  use Conduit.AggregateCase, aggregate: Conduit.Blog.Aggregates.Article

  alias Conduit.Blog.Events.ArticlePublished

  describe "publish article" do
    @tag :unit
    test "should succeed when valid" do
      article_id = UUID.uuid4()
      author_id = UUID.uuid4()

      assert_events(
        build(:publish_article, article_id: article_id, author_id: author_id),
        [
          %ArticlePublished{
            article_id: article_id,
            slug: "how-to-train-your-dragon",
            title: "How to train your dragon",
            description: "Ever wonder how?",
            body: "You have to believe",
            tag_list: ["dragons", "training"],
            author_id: author_id
          }
        ]
      )
    end
  end
end
