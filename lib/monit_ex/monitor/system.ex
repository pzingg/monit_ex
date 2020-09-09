defmodule MonitEx.Monitor.System do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id

  schema "systems" do
    belongs_to(:server, MonitEx.Monitor.Server, type: MonitEx.Ecto.MonitID)

    field :name, :string
    field :status, :string
    field :status_hint, :integer
    field :monitor, :integer
    field :monitor_mode, :integer
    field :pending_action, :integer
    field :date, :integer
    field :load_avg01, :float
    field :load_avg05, :float
    field :load_avg15, :float
    field :cpu_user, :float
    field :cpu_system, :float
    field :cpu_wait, :float
    field :memory_percent, :float
    field :memory_kilobyte, :integer
    field :swap_percent, :float
    field :swap_kilobyte, :integer
    field :data, :map

    timestamps()
  end

  @doc false
  def changeset(system, attrs) do
    system
    |> cast(attrs, [
      :server_id,
      :name,
      :status,
      :status_hint,
      :monitor,
      :monitor_mode,
      :pending_action,
      :date,
      :load_avg01,
      :load_avg05,
      :load_avg15,
      :cpu_user,
      :cpu_system,
      :cpu_wait,
      :memory_percent,
      :memory_kilobyte,
      :swap_percent,
      :swap_kilobyte,
      :data
    ])
    |> validate_required([
      :server_id,
      :name,
      :status,
      :status_hint,
      :monitor,
      :monitor_mode,
      :pending_action,
      :date
    ])
    |> foreign_key_constraint(:server_id)
    |> unique_constraint([:server_id, :name])
  end
end
