defmodule MonitEx.Repo.Migrations.CreateServers do
  use Ecto.Migration

  def change do
    create table(:servers, primary_key: false) do
      add :id, :string, size: 32, primary_key: true
      add :monit_version, :string
      add :hostname, :string
      add :uptime, :integer
      add :address, :string

      timestamps()
    end
  end
end
