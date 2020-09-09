defmodule MonitExWeb.TimeHelpers do
  def duration(nil), do: ""

  def duration(value) when is_integer(value) do
    case Timex.Duration.from_seconds(value)
         |> Timex.format_duration(:humanized) do
      {:error, _} -> "? #{value}"
      str -> str
    end
  end

  def duration(value) when is_binary(value) do
    case Integer.parse(value) do
      {:ok, seconds} ->
        duration(seconds)

      _ ->
        ""
    end
  end

  def relative(nil), do: ""

  def relative(value) when is_integer(value) do
    dt = Timex.from_unix(value, :second)

    formatted =
      if Timex.diff(Timex.now(), dt, :day) > 2 do
        Timex.format(dt, "{Mshort} {D}, {YYYY} {h12}:{m}:{s}{am} {Zabbr}")
      else
        Timex.from_now(dt)
      end

    case formatted do
      {:error, _} -> "? #{value}"
      str -> str
    end
  end

  def relative(value) when is_binary(value) do
    case Integer.parse(value) do
      {:ok, seconds} ->
        relative(seconds)

      _ ->
        ""
    end
  end
end
