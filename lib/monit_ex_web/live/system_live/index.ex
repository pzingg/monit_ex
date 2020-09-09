defmodule MonitExWeb.SystemLive.Index do
  use MonitExWeb, :live_view

  alias MonitEx.Monitor
  alias MonitEx.Monitor.System

  @impl true
  def mount(_params, _session, socket) do
    {:ok, assign(socket, :systems, list_systems())}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, "Edit System")
    |> assign(:system, Monitor.get_system!(id))
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "New System")
    |> assign(:system, %System{})
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Listing Systems")
    |> assign(:system, nil)
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    system = Monitor.get_system!(id)
    {:ok, _} = Monitor.delete_system(system)

    {:noreply, assign(socket, :systems, list_systems())}
  end

  defp list_systems do
    Monitor.list_systems()
  end
end
