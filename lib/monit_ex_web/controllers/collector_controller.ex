defmodule MonitExWeb.CollectorController do
  @moduledoc false

  use MonitExWeb, :controller

  def create(conn, _params) do
    case MonitEx.Monitor.collect_data(conn.body_params, conn.assigns[:basic_auth_credentials]) do
      :ok ->
        conn
        |> put_layout(false)
        |> render("index.xml", %{message: "ok"})

      {:error, {status, message}} ->
        conn
        |> put_status(status)
        |> put_layout(false)
        |> render("index.xml", %{message: message})
    end
  end
end
