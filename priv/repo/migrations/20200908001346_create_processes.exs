defmodule MonitEx.Repo.Migrations.CreateProcesses do
  use Ecto.Migration

  def change do
    create table(:processes, primary_key: false) do
      add :id, :uuid, primary_key: true
      add :name, :string
      add :status, :string
      add :status_hint, :integer
      add :monitor, :integer
      add :monitor_mode, :integer
      add :pending_action, :integer
      add :pid, :integer
      add :ppid, :integer
      add :uptime, :integer
      add :children, :integer
      add :date, :integer
      add :cpu_percent, :float
      add :memory_percent, :float
      add :memory_kilobyte, :integer
      add :data, :map
      add :server_id, references(:servers, type: :string, on_delete: :nothing), size: 32

      timestamps()
    end

    create index(:processes, [:server_id])
    create unique_index(:processes, [:server_id, :name])
  end
end
