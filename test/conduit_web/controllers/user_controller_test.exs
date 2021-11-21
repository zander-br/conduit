defmodule ConduitWeb.UserControllerTest do
  use ConduitWeb.ConnCase

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "register user" do
    @tag :web
    test "should create and return user when data is valid", %{conn: conn} do
      conn = post(conn, Routes.user_path(conn, :create), user: build(:user))
      json = json_response(conn, 201)["user"]
      token = json["token"]

      assert json == %{
               "bio" => nil,
               "email" => "jake@jake.jake",
               "token" => token,
               "image" => nil,
               "username" => "jake"
             }

      refute token == ""
    end

    @tag :web
    test "should not create user and render errors when data is invalid", %{conn: conn} do
      conn = post(conn, Routes.user_path(conn, :create), user: build(:user, username: ""))

      assert json_response(conn, 422)["errors"] == %{
               "username" => [
                 "can't be empty"
               ]
             }
    end

    @tag :web
    test "should not create user and render erros when username has been taken", %{conn: conn} do
      {:ok, _user} = fixture(:user)

      conn =
        post(conn, Routes.user_path(conn, :create), user: build(:user, email: "jake2@jake.jake"))

      assert json_response(conn, 422)["errors"] == %{
               "username" => [
                 "has already been taken"
               ]
             }
    end
  end
end
