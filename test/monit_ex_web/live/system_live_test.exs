defmodule MonitExWeb.SystemLiveTest do
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
    date: 42,
    load_avg01: 120.5,
    load_avg05: 120.5,
    load_avg15: 120.5,
    monitor: 42,
    monitor_mode: 42,
    name: "some name",
    pending_action: 42,
    status: "some status",
    status_hint: 42
  }
  @update_attrs %{
    date: 43,
    load_avg01: 456.7,
    load_avg05: 456.7,
    load_avg15: 456.7,
    monitor: 43,
    monitor_mode: 43,
    name: "some updated name",
    pending_action: 43,
    status: "some updated status",
    status_hint: 43
  }
  @invalid_attrs %{
    date: nil,
    load_avg01: nil,
    load_avg05: nil,
    load_avg15: nil,
    monitor: nil,
    monitor_mode: nil,
    name: nil,
    pending_action: nil,
    status: nil,
    status_hint: nil
  }

  defp fixture(:system) do
    {:ok, server} = Monitor.create_server(@server_attrs)
    {:ok, system} = Monitor.create_system(@create_attrs |> Map.put(:server_id, server.id))
    system
  end

  defp create_system(_) do
    system = fixture(:system)
    %{system: system}
  end

  describe "Index" do
    setup [:create_system]

    test "lists all systems", %{conn: conn, system: system} do
      {:ok, _index_live, html} = live(conn, Routes.system_index_path(conn, :index))

      assert html =~ "Listing Systems"
      assert html =~ system.status
    end

    test "saves new system", %{conn: conn} do
      {:ok, index_live, _html} = live(conn, Routes.system_index_path(conn, :index))

      assert index_live |> element("a", "New System") |> render_click() =~
               "New System"

      assert_patch(index_live, Routes.system_index_path(conn, :new))

      assert index_live
             |> form("#system-form", system: @invalid_attrs)
             |> render_change() =~ "can&apos;t be blank"

      {:ok, _, html} =
        index_live
        |> form("#system-form", system: @create_attrs)
        |> render_submit()
        |> follow_redirect(conn, Routes.system_index_path(conn, :index))

      assert html =~ "System created successfully"
      assert html =~ "some status"
    end

    test "updates system in listing", %{conn: conn, system: system} do
      {:ok, index_live, _html} = live(conn, Routes.system_index_path(conn, :index))

      assert index_live |> element("#system-#{system.id} a", "Edit") |> render_click() =~
               "Edit System"

      assert_patch(index_live, Routes.system_index_path(conn, :edit, system))

      assert index_live
             |> form("#system-form", system: @invalid_attrs)
             |> render_change() =~ "can&apos;t be blank"

      {:ok, _, html} =
        index_live
        |> form("#system-form", system: @update_attrs)
        |> render_submit()
        |> follow_redirect(conn, Routes.system_index_path(conn, :index))

      assert html =~ "System updated successfully"
      assert html =~ "some updated status"
    end

    test "deletes system in listing", %{conn: conn, system: system} do
      {:ok, index_live, _html} = live(conn, Routes.system_index_path(conn, :index))

      assert index_live |> element("#system-#{system.id} a", "Delete") |> render_click()
      refute has_element?(index_live, "#system-#{system.id}")
    end
  end

  describe "Show" do
    setup [:create_system]

    test "displays system", %{conn: conn, system: system} do
      {:ok, _show_live, html} = live(conn, Routes.system_show_path(conn, :show, system))

      assert html =~ "Show System"
      assert html =~ system.status
    end

    test "updates system within modal", %{conn: conn, system: system} do
      {:ok, show_live, _html} = live(conn, Routes.system_show_path(conn, :show, system))

      assert show_live |> element("a", "Edit") |> render_click() =~
               "Edit System"

      assert_patch(show_live, Routes.system_show_path(conn, :edit, system))

      assert show_live
             |> form("#system-form", system: @invalid_attrs)
             |> render_change() =~ "can&apos;t be blank"

      {:ok, _, html} =
        show_live
        |> form("#system-form", system: @update_attrs)
        |> render_submit()
        |> follow_redirect(conn, Routes.system_show_path(conn, :show, system))

      assert html =~ "System updated successfully"
      assert html =~ "some updated status"
    end
  end
end
