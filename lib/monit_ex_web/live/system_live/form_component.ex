defmodule MonitExWeb.SystemLive.FormComponent do
  use MonitExWeb, :live_component

  alias MonitEx.Monitor

  @impl true
  def update(%{system: system} = assigns, socket) do
    changeset = Monitor.change_system(system)

    {:ok,
     socket
     |> assign(assigns)
     |> assign(:changeset, changeset)}
  end

  @impl true
  def handle_event("validate", %{"system" => system_params}, socket) do
    changeset =
      socket.assigns.system
      |> Monitor.change_system(system_params)
      |> Map.put(:action, :validate)

    {:noreply, assign(socket, :changeset, changeset)}
  end

  def handle_event("save", %{"system" => system_params}, socket) do
    save_system(socket, socket.assigns.action, system_params)
  end

  defp save_system(socket, :edit, system_params) do
    case Monitor.update_system(socket.assigns.system, system_params) do
      {:ok, _system} ->
        {:noreply,
         socket
         |> put_flash(:info, "System updated successfully")
         |> push_redirect(to: socket.assigns.return_to)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, :changeset, changeset)}
    end
  end

  defp save_system(socket, :new, system_params) do
    case Monitor.create_system(system_params) do
      {:ok, _system} ->
        {:noreply,
         socket
         |> put_flash(:info, "System created successfully")
         |> push_redirect(to: socket.assigns.return_to)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, changeset: changeset)}
    end
  end
end
