defmodule MonitEx.Repo.Migrations.CreatePlatforms do
  use Ecto.Migration

  def change do
    create table(:platforms, primary_key: false) do
      add :id, :uuid, primary_key: true
      add :name, :string
      add :release, :string
      add :version, :string
      add :machine, :string
      add :cpu, :integer
      add :memory, :integer
      add :swap, :integer
      add :server_id, references(:servers, type: :string, on_delete: :nothing), size: 32

      timestamps()
    end

    create index(:platforms, [:server_id])
    create unique_index(:platforms, [:server_id, :name])
  end
end
