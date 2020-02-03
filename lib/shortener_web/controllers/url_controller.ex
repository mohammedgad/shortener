defmodule ShortenerWeb.UrlController do
  use ShortenerWeb, :controller

  alias Shortener.Web
  alias Shortener.Web.Url

  def index(conn, _params) do
    urls = Web.list_urls()
    changeset = Web.change_url(%Url{})
    render(conn, "index.html", urls: urls, changeset: changeset)
  end

  def create(conn, %{"url" => url_params}) do
    urls = Web.list_urls()

    case Web.create_url(url_params) do
      {:ok, _url} ->
        conn
        |> put_flash(:info, "Url created successfully.")
        |> redirect(to: Routes.url_path(conn, :index))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "index.html", urls: urls, changeset: changeset)

      {:error, message} ->
        conn
        |> put_flash(:error, message)
        |> redirect(to: Routes.url_path(conn, :index))
    end
  end

  def redirections(conn, %{"slug" => slug}) do
    case Web.get_url!(slug) do
      {:error, message} ->
        conn
        |> put_flash(:error, message)
        |> redirect(to: Routes.url_path(conn, :index))

      url ->
        Web.update_url(url, %{clicks: url.clicks + 1})
        redirect(conn, external: url.long_url)
    end
  end

  def show(conn, %{"id" => id}) do
    url = Web.get_url!(id)
    render(conn, "show.html", url: url)
  end
end
