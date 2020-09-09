defmodule MonitEx.Monitor.Process do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id

  schema "processes" do
    belongs_to(:server, MonitEx.Monitor.Server, type: MonitEx.Ecto.MonitID)

    field :name, :string
    field :children, :integer
    field :monitor, :integer
    field :monitor_mode, :integer
    field :pending_action, :integer
    field :pid, :integer
    field :ppid, :integer
    field :status, :string
    field :status_hint, :integer
    field :uptime, :integer
    field :date, :integer
    field :cpu_percent, :float
    field :memory_kilobyte, :integer
    field :memory_percent, :float
    field :data, :map

    timestamps()
  end

  @doc false
  def changeset(process, attrs) do
    process
    |> cast(attrs, [
      :server_id,
      :name,
      :status,
      :status_hint,
      :monitor,
      :monitor_mode,
      :pending_action,
      :pid,
      :ppid,
      :uptime,
      :children,
      :date,
      :cpu_percent,
      :memory_percent,
      :memory_kilobyte,
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
