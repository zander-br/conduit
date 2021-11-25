defmodule Conduit.Blog.Aggregates.ArticleTest do
  use Conduit.AggregateCase, aggregate: Conduit.Blog.Aggregates.Article

  alias Conduit.Blog.Commands.{FavoriteArticle, UnfavoriteArticle}
  alias Conduit.Blog.Events.{ArticleFavorited, ArticleUnfavorited}

  describe "publish article" do
    @tag :unit
    test "should succeed when valid" do
      article_id = UUID.uuid4()
      author_id = UUID.uuid4()

      assert_events(
        build(:publish_article, article_id: article_id, author_id: author_id),
        [
          build(:article_published, article_id: article_id, author_id: author_id)
        ]
      )
    end
  end

  describe "favorite article" do
    @tag :unit
    test "should succeed when not already a favorite" do
      article_id = UUID.uuid4()
      author_id = UUID.uuid4()

      assert_events(
        build(:article_published, article_id: article_id, author_id: author_id),
        %FavoriteArticle{article_id: article_id, favorited_by_author_id: author_id},
        [
          %ArticleFavorited{
            article_id: article_id,
            favorited_by_author_id: author_id,
            favorite_count: 1
          }
        ]
      )
    end

    test "should ignore when already a favorite" do
      article_id = UUID.uuid4()
      author_id = UUID.uuid4()

      assert_events(
        build(:article_published, article_id: article_id, author_id: author_id),
        [
          %FavoriteArticle{article_id: article_id, favorited_by_author_id: author_id},
          %FavoriteArticle{article_id: article_id, favorited_by_author_id: author_id}
        ],
        []
      )
    end
  end

  describe "unfavorite article" do
    @tag :unit
    test "should succed when a favorite" do
      article_id = UUID.uuid4()
      author_id = UUID.uuid4()

      assert_events(
        build(:article_published, article_id: article_id, author_id: author_id),
        [
          %FavoriteArticle{article_id: article_id, favorited_by_author_id: author_id},
          %UnfavoriteArticle{article_id: article_id, unfavorited_by_author_id: author_id}
        ],
        [
          %ArticleUnfavorited{
            article_id: article_id,
            unfavorited_by_author_id: author_id,
            favorite_count: 0
          }
        ]
      )
    end

    @tag :unit
    test "should ignore when not a favorite" do
      article_id = UUID.uuid4()
      author_id = UUID.uuid4()

      assert_events(
        build(:article_published, article_id: article_id, author_id: author_id),
        [
          %UnfavoriteArticle{article_id: article_id, unfavorited_by_author_id: author_id}
        ],
        []
      )
    end
  end
end
