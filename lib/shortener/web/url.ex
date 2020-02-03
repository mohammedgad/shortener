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
  end
end
