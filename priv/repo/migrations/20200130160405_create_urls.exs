defmodule Shortener.Repo.Migrations.CreateUrls do
  use Ecto.Migration

  def change do
    create table(:urls) do
      add :long_url, :string
      add :slug, :string
      add :clicks, :integer, defualt: 0

      timestamps()
    end
  end
end
