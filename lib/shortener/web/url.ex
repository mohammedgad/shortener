defmodule Shortener.Web.Url do
  use Ecto.Schema
  import Ecto.Changeset

  schema "urls" do
    field :clicks, :integer, default: 0
    field :long_url, :string
    field :slug, :string

    timestamps()
  end

  def changeset(url, attrs) do
    url
    |> cast(attrs, [:clicks, :long_url, :slug])
    |> validate_required([:long_url, :slug])
    |> validate_url(:long_url)
  end

  def validate_url(changeset, field, opts \\ []) do
    validate_change(changeset, field, fn _, value ->
      case URI.parse(value) do
        %URI{scheme: nil} ->
          "is missing a scheme (e.g. https)"

        %URI{host: nil} ->
          "is missing a host"

        %URI{host: host} ->
          case :inet.gethostbyname(Kernel.to_charlist(host)) do
            {:ok, _} -> nil
            {:error, _} -> "invalid host"
          end
      end
      |> case do
        error when is_binary(error) -> [{field, Keyword.get(opts, :message, error)}]
        _ -> []
      end
    end)
  end
end
