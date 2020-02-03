defmodule ShortenerWeb.UrlControllerTest do
  use ShortenerWeb.ConnCase

  @create_attrs %{long_url: "some long_url", slug: "some slug"}
  @invalid_attrs %{clicks: nil, long_url: nil, slug: nil}

  describe "index" do
    test "lists all urls", %{conn: conn} do
      conn = get(conn, Routes.url_path(conn, :index))
      assert html_response(conn, 200) =~ "URLs Shortener"
    end
  end

  describe "create url" do
    test "redirects to index when data is valid", %{conn: conn} do
      conn = post(conn, Routes.url_path(conn, :create), url: @create_attrs)
      assert redirected_to(conn) == Routes.url_path(conn, :index)
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, Routes.url_path(conn, :index), url: @invalid_attrs)
      assert html_response(conn, 302)
    end
  end
end
