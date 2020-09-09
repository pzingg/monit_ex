defmodule MonitEx.Monitor.Server do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, MonitEx.Ecto.MonitID, autogenerate: false}
  @foreign_key_type MonitEx.Ecto.MonitID

  schema "servers" do
    has_one(:platform, MonitEx.Monitor.Platform)
    has_one(:system, MonitEx.Monitor.System)
    has_many(:processes, MonitEx.Monitor.Process)

    field :address, :string
    field :hostname, :string
    field :monit_version, :string
    field :uptime, :integer

    timestamps()
  end

  @doc """
  :address is not required.
  """
  def changeset(server, attrs) do
    server
    |> cast(attrs, [:id, :monit_version, :hostname, :uptime, :address])
    |> validate_required([:id, :monit_version, :hostname, :uptime])
    |> unique_constraint(:id, name: :servers_pkey)
  end
end
