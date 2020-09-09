defmodule MonitExWeb.ServerLive.Index do
  use MonitExWeb, :live_view

  alias MonitEx.Monitor
  alias MonitEx.Monitor.Server

  @impl true
  def mount(_params, _session, socket) do
    {:ok, assign(socket, :servers, list_servers())}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, "Edit Server")
    |> assign(:server, Monitor.get_server!(id))
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "New Server")
    |> assign(:server, %Server{})
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Listing Servers")
    |> assign(:server, nil)
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    server = Monitor.get_server!(id)
    {:ok, _} = Monitor.delete_server(server)

    {:noreply, assign(socket, :servers, list_servers())}
  end

  defp list_servers do
    Monitor.list_servers()
  end
end
