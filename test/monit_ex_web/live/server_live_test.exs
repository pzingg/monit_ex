defmodule MonitExWeb.ServerLiveTest do
  use MonitExWeb.ConnCase

  import Phoenix.LiveViewTest

  alias MonitEx.Monitor

  @create_attrs %{
    id: "84ef6387f1ca5e1dc8b4f8565620ffa6",
    address: "some address",
    hostname: "some hostname",
    monit_version: "some monit_version",
    uptime: 42
  }
  @update_attrs %{
    address: "some updated address",
    hostname: "some updated hostname",
    monit_version: "some updated monit_version",
    uptime: 43
  }
  @invalid_attrs %{address: nil, hostname: nil, monit_version: nil, uptime: nil}

  defp fixture(:server) do
    {:ok, server} = Monitor.create_server(@create_attrs)
    server
  end

  defp create_server(_) do
    server = fixture(:server)
    %{server: server}
  end

  describe "Index" do
    setup [:create_server]

    test "lists all servers", %{conn: conn, server: server} do
      {:ok, _index_live, html} = live(conn, Routes.server_index_path(conn, :index))

      assert html =~ "Listing Servers"
      assert html =~ server.address
    end

    test "saves new server", %{conn: conn} do
      {:ok, index_live, _html} = live(conn, Routes.server_index_path(conn, :index))

      assert index_live |> element("a", "New Server") |> render_click() =~
               "New Server"

      assert_patch(index_live, Routes.server_index_path(conn, :new))

      assert index_live
             |> form("#server-form", server: @invalid_attrs)
             |> render_change() =~ "can&apos;t be blank"

      {:ok, _, html} =
        index_live
        |> form("#server-form", server: @create_attrs)
        |> render_submit()
        |> follow_redirect(conn, Routes.server_index_path(conn, :index))

      assert html =~ "Server created successfully"
      assert html =~ "some address"
    end

    test "updates server in listing", %{conn: conn, server: server} do
      {:ok, index_live, _html} = live(conn, Routes.server_index_path(conn, :index))

      assert index_live |> element("#server-#{server.id} a", "Edit") |> render_click() =~
               "Edit Server"

      assert_patch(index_live, Routes.server_index_path(conn, :edit, server))

      assert index_live
             |> form("#server-form", server: @invalid_attrs)
             |> render_change() =~ "can&apos;t be blank"

      {:ok, _, html} =
        index_live
        |> form("#server-form", server: @update_attrs)
        |> render_submit()
        |> follow_redirect(conn, Routes.server_index_path(conn, :index))

      assert html =~ "Server updated successfully"
      assert html =~ "some updated address"
    end

    test "deletes server in listing", %{conn: conn, server: server} do
      {:ok, index_live, _html} = live(conn, Routes.server_index_path(conn, :index))

      assert index_live |> element("#server-#{server.id} a", "Delete") |> render_click()
      refute has_element?(index_live, "#server-#{server.id}")
    end
  end

  describe "Show" do
    setup [:create_server]

    test "displays server", %{conn: conn, server: server} do
      {:ok, _show_live, html} = live(conn, Routes.server_show_path(conn, :show, server))

      assert html =~ "Show Server"
      assert html =~ server.address
    end

    test "updates server within modal", %{conn: conn, server: server} do
      {:ok, show_live, _html} = live(conn, Routes.server_show_path(conn, :show, server))

      assert show_live |> element("a", "Edit") |> render_click() =~
               "Edit Server"

      assert_patch(show_live, Routes.server_show_path(conn, :edit, server))

      assert show_live
             |> form("#server-form", server: @invalid_attrs)
             |> render_change() =~ "can&apos;t be blank"

      {:ok, _, html} =
        show_live
        |> form("#server-form", server: @update_attrs)
        |> render_submit()
        |> follow_redirect(conn, Routes.server_show_path(conn, :show, server))

      assert html =~ "Server updated successfully"
      assert html =~ "some updated address"
    end
  end
end
