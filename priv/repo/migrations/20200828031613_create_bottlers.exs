defmodule Market.Repo.Migrations.CreateBottlers do
  use Ecto.Migration

  def change do
    create table(:providers) do
      add :name, :string

      timestamps()
    end

    create table(:pairs) do
      add :name, :string
      add :provider_id, references(:providers, on_delete: :delete_all)

      timestamps()
    end

    create index(:pairs, [:provider_id])

    create table(:bottlers) do
      add :price, :decimal
      add :quantity, :integer
      add :date, :utc_datetime
      add :pair_id, references(:pairs, on_delete: :delete_all)

      timestamps()
    end

    create index(:bottlers, [:pair_id])
  end
end
