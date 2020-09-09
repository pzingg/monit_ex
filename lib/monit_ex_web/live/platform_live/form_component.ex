defmodule MonitExWeb.PlatformLive.FormComponent do
  use MonitExWeb, :live_component

  alias MonitEx.Monitor

  @impl true
  def update(%{platform: platform} = assigns, socket) do
    changeset = Monitor.change_platform(platform)

    {:ok,
     socket
     |> assign(assigns)
     |> assign(:changeset, changeset)}
  end

  @impl true
  def handle_event("validate", %{"platform" => platform_params}, socket) do
    changeset =
      socket.assigns.platform
      |> Monitor.change_platform(platform_params)
      |> Map.put(:action, :validate)

    {:noreply, assign(socket, :changeset, changeset)}
  end

  def handle_event("save", %{"platform" => platform_params}, socket) do
    save_platform(socket, socket.assigns.action, platform_params)
  end

  defp save_platform(socket, :edit, platform_params) do
    case Monitor.update_platform(socket.assigns.platform, platform_params) do
      {:ok, _platform} ->
        {:noreply,
         socket
         |> put_flash(:info, "Platform updated successfully")
         |> push_redirect(to: socket.assigns.return_to)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, :changeset, changeset)}
    end
  end

  defp save_platform(socket, :new, platform_params) do
    case Monitor.create_platform(platform_params) do
      {:ok, _platform} ->
        {:noreply,
         socket
         |> put_flash(:info, "Platform created successfully")
         |> push_redirect(to: socket.assigns.return_to)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, changeset: changeset)}
    end
  end
end
