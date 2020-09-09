defmodule MonitExWeb.PlatformLive.Index do
  use MonitExWeb, :live_view

  alias MonitEx.Monitor
  alias MonitEx.Monitor.Platform

  @impl true
  def mount(_params, _session, socket) do
    {:ok, assign(socket, :platforms, list_platforms())}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, "Edit Platform")
    |> assign(:platform, Monitor.get_platform!(id))
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "New Platform")
    |> assign(:platform, %Platform{})
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Listing Platforms")
    |> assign(:platform, nil)
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    platform = Monitor.get_platform!(id)
    {:ok, _} = Monitor.delete_platform(platform)

    {:noreply, assign(socket, :platforms, list_platforms())}
  end

  defp list_platforms do
    Monitor.list_platforms()
  end
end
