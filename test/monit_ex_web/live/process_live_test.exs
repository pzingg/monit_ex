defmodule MonitExWeb.ProcessLiveTest do
  use MonitExWeb.ConnCase

  import Phoenix.LiveViewTest

  alias MonitEx.Monitor

  @server_attrs %{
    id: "84ef6387f1ca5e1dc8b4f8565620ffa6",
    address: "some address",
    hostname: "some hostname",
    monit_version: "some monit_version",
    uptime: 42
  }
  @create_attrs %{
    children: 42,
    cpu_percent: 120.5,
    date: 42,
    memory_kilobyte: 42,
    memory_percent: 120.5,
    monitor: 42,
    monitor_mode: 42,
    name: "some name",
    pending_action: 42,
    pid: 42,
    ppid: 42,
    status: "some status",
    status_hint: 42,
    uptime: 42
  }
  @update_attrs %{
    children: 43,
    cpu_percent: 456.7,
    date: 43,
    memory_kilobyte: 43,
    memory_percent: 456.7,
    monitor: 43,
    monitor_mode: 43,
    name: "some updated name",
    pending_action: 43,
    pid: 43,
    ppid: 43,
    status: "some updated status",
    status_hint: 43,
    uptime: 43
  }
  @invalid_attrs %{
    children: nil,
    cpu_percent: nil,
    date: nil,
    memory_kilobyte: nil,
    memory_percent: nil,
    monitor: nil,
    monitor_mode: nil,
    name: nil,
    pending_action: nil,
    pid: nil,
    ppid: nil,
    status: nil,
    status_hint: nil,
    uptime: nil
  }

  defp fixture(:process) do
    {:ok, server} = Monitor.create_server(@server_attrs)
    {:ok, process} = Monitor.create_process(@create_attrs |> Map.put(:server_id, server.id))
    process
  end

  defp create_process(_) do
    process = fixture(:process)
    %{process: process}
  end

  describe "Index" do
    setup [:create_process]

    test "lists all processes", %{conn: conn, process: process} do
      {:ok, _index_live, html} = live(conn, Routes.process_index_path(conn, :index))

      assert html =~ "Listing Processes"
      assert html =~ process.status
    end

    test "saves new process", %{conn: conn} do
      {:ok, index_live, _html} = live(conn, Routes.process_index_path(conn, :index))

      assert index_live |> element("a", "New Process") |> render_click() =~
               "New Process"

      assert_patch(index_live, Routes.process_index_path(conn, :new))

      assert index_live
             |> form("#process-form", process: @invalid_attrs)
             |> render_change() =~ "can&apos;t be blank"

      {:ok, _, html} =
        index_live
        |> form("#process-form", process: @create_attrs)
        |> render_submit()
        |> follow_redirect(conn, Routes.process_index_path(conn, :index))

      assert html =~ "Process created successfully"
      assert html =~ "some status"
    end

    test "updates process in listing", %{conn: conn, process: process} do
      {:ok, index_live, _html} = live(conn, Routes.process_index_path(conn, :index))

      assert index_live |> element("#process-#{process.id} a", "Edit") |> render_click() =~
               "Edit Process"

      assert_patch(index_live, Routes.process_index_path(conn, :edit, process))

      assert index_live
             |> form("#process-form", process: @invalid_attrs)
             |> render_change() =~ "can&apos;t be blank"

      {:ok, _, html} =
        index_live
        |> form("#process-form", process: @update_attrs)
        |> render_submit()
        |> follow_redirect(conn, Routes.process_index_path(conn, :index))

      assert html =~ "Process updated successfully"
      assert html =~ "some updated status"
    end

    test "deletes process in listing", %{conn: conn, process: process} do
      {:ok, index_live, _html} = live(conn, Routes.process_index_path(conn, :index))

      assert index_live |> element("#process-#{process.id} a", "Delete") |> render_click()
      refute has_element?(index_live, "#process-#{process.id}")
    end
  end

  describe "Show" do
    setup [:create_process]

    test "displays process", %{conn: conn, process: process} do
      {:ok, _show_live, html} = live(conn, Routes.process_show_path(conn, :show, process))

      assert html =~ "Show Process"
      assert html =~ process.status
    end

    test "updates process within modal", %{conn: conn, process: process} do
      {:ok, show_live, _html} = live(conn, Routes.process_show_path(conn, :show, process))

      assert show_live |> element("a", "Edit") |> render_click() =~
               "Edit Process"

      assert_patch(show_live, Routes.process_show_path(conn, :edit, process))

      assert show_live
             |> form("#process-form", process: @invalid_attrs)
             |> render_change() =~ "can&apos;t be blank"

      {:ok, _, html} =
        show_live
        |> form("#process-form", process: @update_attrs)
        |> render_submit()
        |> follow_redirect(conn, Routes.process_show_path(conn, :show, process))

      assert html =~ "Process updated successfully"
      assert html =~ "some updated status"
    end
  end
end
