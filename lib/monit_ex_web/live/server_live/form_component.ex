defmodule MonitExWeb.ServerLive.FormComponent do
  use MonitExWeb, :live_component

  alias MonitEx.Monitor

  @impl true
  def update(%{server: server} = assigns, socket) do
    changeset = Monitor.change_server(server)

    {:ok,
     socket
     |> assign(assigns)
     |> assign(:changeset, changeset)}
  end

  @impl true
  def handle_event("validate", %{"server" => server_params}, socket) do
    changeset =
      socket.assigns.server
      |> Monitor.change_server(server_params)
      |> Map.put(:action, :validate)

    {:noreply, assign(socket, :changeset, changeset)}
  end

  def handle_event("save", %{"server" => server_params}, socket) do
    save_server(socket, socket.assigns.action, server_params)
  end

  defp save_server(socket, :edit, server_params) do
    case Monitor.update_server(socket.assigns.server, server_params) do
      {:ok, _server} ->
        {:noreply,
         socket
         |> put_flash(:info, "Server updated successfully")
         |> push_redirect(to: socket.assigns.return_to)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, :changeset, changeset)}
    end
  end

  defp save_server(socket, :new, server_params) do
    case Monitor.create_server(server_params) do
      {:ok, _server} ->
        {:noreply,
         socket
         |> put_flash(:info, "Server created successfully")
         |> push_redirect(to: socket.assigns.return_to)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, changeset: changeset)}
    end
  end
end
