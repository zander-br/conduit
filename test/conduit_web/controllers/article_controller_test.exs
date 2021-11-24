defmodule ConduitWeb.ArticleControllerTest do
  use ConduitWeb.ConnCase

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "publish article" do
    @tag :web
    test "should create and return article when data is valid", %{conn: conn} do
      conn =
        post(authenticated_conn(conn), Routes.article_path(conn, :create),
          article: build(:article)
        )

      json = json_response(conn, 201)["article"]
      created_at = json["createdAt"]
      updated_at = json["updatedAt"]

      assert json == %{
               "slug" => "how-to-train-your-dragon",
               "title" => "How to train your dragon",
               "description" => "Ever wonder how?",
               "body" => "You have to believe",
               "tagList" => ["dragons", "training"],
               "createdAt" => created_at,
               "updatedAt" => updated_at,
               "favorited" => false,
               "favoritesCount" => 0,
               "author" => %{
                 "username" => "jake",
                 "bio" => nil,
                 "image" => nil,
                 "following" => false
               }
             }

      refute created_at == ""
      refute updated_at == ""
    end
  end

  describe "list articles" do
    setup [
      :create_author,
      :publish_articles
    ]

    @tag :web
    test "should return published articles by date published", %{conn: conn} do
      conn = get(conn, Routes.article_path(conn, :index))
      json = json_response(conn, 200)
      articles = json["articles"]
      first_created_at = Enum.at(articles, 0)["createdAt"]
      first_updated_at = Enum.at(articles, 0)["updatedAt"]
      second_created_at = Enum.at(articles, 1)["createdAt"]
      second_updated_at = Enum.at(articles, 1)["updatedAt"]

      assert json == %{
               "articles" => [
                 %{
                   "slug" => "how-to-train-your-dragon-2",
                   "title" => "How to train your dragon 2",
                   "description" => "So toothless",
                   "body" => "It a dragon",
                   "tagList" => ["dragons", "training"],
                   "createdAt" => first_created_at,
                   "updatedAt" => first_updated_at,
                   "favorited" => false,
                   "favoritesCount" => 0,
                   "author" => %{
                     "username" => "jake",
                     "bio" => nil,
                     "image" => nil,
                     "following" => false
                   }
                 },
                 %{
                   "slug" => "how-to-train-your-dragon",
                   "title" => "How to train your dragon",
                   "description" => "Ever wonder how?",
                   "body" => "You have to believe",
                   "tagList" => ["dragons", "training"],
                   "createdAt" => second_created_at,
                   "updatedAt" => second_updated_at,
                   "favorited" => false,
                   "favoritesCount" => 0,
                   "author" => %{
                     "username" => "jake",
                     "bio" => nil,
                     "image" => nil,
                     "following" => false
                   }
                 }
               ],
               "articlesCount" => 2
             }
    end
  end
end
