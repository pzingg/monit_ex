defmodule MonitEx.Ecto.MonitID do
  @moduledoc """
  An Ecto type for strings.
  Monit sends id's like this: "84ef6387f1ca5e1dc8b4f8565620ffa6"
  """

  use Ecto.Type

  @typedoc """
  A 32-byte (256 bits) string.
  """
  @type t :: <<_::256>>

  @type raw :: <<_::256>>

  @doc false
  def type, do: :string

  @doc """
  Custom casting rule for changesets. Cast fails unless string is exactly 256 bits.
  Convert string data from (for example) HTML forms into the shape used by the schema.
  """
  @spec cast(raw | any) :: {:ok, t} | :error
  def cast(<<_::256>> = id) do
    {:ok, id}
  end

  def cast(_), do: :error

  @doc """
  Same as `cast/1` but raises `Ecto.CastError` on invalid arguments.
  """
  @spec cast!(raw | any) :: t
  def cast!(value) do
    case cast(value) do
      {:ok, id} -> id
      :error -> raise Ecto.CastError, type: __MODULE__, value: value
    end
  end

  @doc """
  Convert data returned by the database into the shape used by the schema.
  """
  @spec load(raw | any) :: {:ok, t} | :error
  def load(<<_::256>> = id) do
    cast(id)
  end

  def load(_), do: :error

  @doc """
  Convert schema data into the type that will be stored in the database.
  """
  @spec dump(t | any) :: {:ok, raw} | :error
  def dump(<<_::256>> = id) do
    {:ok, id}
  end

  def dump(_), do: :error
end
