defmodule MonitEx.Monitor.Platform do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id

  schema "platforms" do
    belongs_to(:server, MonitEx.Monitor.Server, type: MonitEx.Ecto.MonitID)

    field :cpu, :integer
    field :machine, :string
    field :memory, :integer
    field :name, :string
    field :release, :string
    field :swap, :integer
    field :version, :string

    timestamps()
  end

  @doc false
  def changeset(platform, attrs) do
    platform
    |> cast(attrs, [:server_id, :name, :release, :version, :machine, :cpu, :memory, :swap])
    |> validate_required([:server_id, :name, :release, :version, :machine, :cpu, :memory, :swap])
    |> foreign_key_constraint(:server_id)
    |> unique_constraint([:server_id, :name])
  end
end
