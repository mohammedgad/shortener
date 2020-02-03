defmodule Shortener.Web do
  @moduledoc """
  The Web context.
  """

  import Ecto.Query, warn: false
  alias Shortener.Repo

  alias Shortener.Web.Url

  def list_urls do
    Url
    |> order_by(desc: :inserted_at)
    |> limit(5)
    |> Repo.all()
  end

  def get_url!(slug) when is_binary(slug) do
    case Repo.get_by(Url, slug: slug) do
      nil -> {:error, "url is invalid"}
      url -> url
    end
  end

  def get_url!(id), do: Repo.get!(Url, id)

  def create_url(attrs \\ %{}) do
    with attrs <- generate_slug_if_not_exists(attrs),
         {:ok, _slug} <- validate_slug_uniqueness(attrs) do
      %Url{}
      |> Url.changeset(attrs)
      |> Repo.insert()
    end
  end

  def update_url(%Url{} = url, attrs) do
    url
    |> Url.changeset(attrs)
    |> Repo.update()
  end

  def delete_url(%Url{} = url) do
    Repo.delete(url)
  end

  def change_url(%Url{} = url) do
    Url.changeset(url, %{})
  end

  def generate_slug_if_not_exists(attrs) do
    attrs
    |> do_generate_slug_if_not_exists
  end

  def do_generate_slug_if_not_exists(attrs = %{"slug" => ""}) do
    slug =
      :crypto.strong_rand_bytes(5)
      |> Base.url_encode64(padding: false)

    attrs = attrs |> Map.put("slug", slug)

    case validate_slug_uniqueness(attrs) do
      {:ok, _} -> attrs
      _ -> do_generate_slug_if_not_exists(attrs)
    end
  end

  def do_generate_slug_if_not_exists(attrs), do: attrs

  def validate_slug_uniqueness(%{slug: slug}) do
    validate_slug_uniqueness(slug)
  end

  def validate_slug_uniqueness(%{"slug" => slug}) do
    validate_slug_uniqueness(slug)
  end

  def validate_slug_uniqueness(slug) when is_binary(slug) do
    case Repo.get_by(Url, slug: slug) do
      nil -> {:ok, slug}
      _url -> {:error, "Slug already exists"}
    end
  end

  def validate_slug_uniqueness(nil), do: {:error, "slug is required"}
end
