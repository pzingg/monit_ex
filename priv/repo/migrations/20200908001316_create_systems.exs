defmodule MonitEx.Repo.Migrations.CreateSystems do
  use Ecto.Migration

  def change do
    create table(:systems, primary_key: false) do
      add :id, :uuid, primary_key: true
      add :name, :string
      add :status, :string
      add :status_hint, :integer
      add :monitor, :integer
      add :monitor_mode, :integer
      add :pending_action, :integer
      add :date, :integer
      add :load_avg01, :float
      add :load_avg05, :float
      add :load_avg15, :float
      add :cpu_user, :float
      add :cpu_system, :float
      add :cpu_wait, :float
      add :memory_percent, :float
      add :memory_kilobyte, :integer
      add :swap_percent, :float
      add :swap_kilobyte, :integer
      add :data, :map
      add :server_id, references(:servers, type: :string, on_delete: :nothing), size: 32

      timestamps()
    end

    create index(:systems, [:server_id])
    create unique_index(:systems, [:server_id, :name])
  end
end
