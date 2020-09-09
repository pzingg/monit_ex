defmodule MonitExWeb.PlatformLiveTest do
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
    cpu: 42,
    machine: "some machine",
    memory: 42,
    name: "some name",
    release: "some release",
    swap: 42,
    version: "some version"
  }
  @update_attrs %{
    cpu: 43,
    machine: "some updated machine",
    memory: 43,
    name: "some updated name",
    release: "some updated release",
    swap: 43,
    version: "some updated version"
  }
  @invalid_attrs %{
    cpu: nil,
    machine: nil,
    memory: nil,
    name: nil,
    release: nil,
    swap: nil,
    version: nil
  }

  defp fixture(:platform) do
    {:ok, server} = Monitor.create_server(@server_attrs)
    {:ok, platform} = Monitor.create_platform(@create_attrs |> Map.put(:server_id, server.id))
    platform
  end

  defp create_platform(_) do
    platform = fixture(:platform)
    %{platform: platform}
  end

  describe "Index" do
    setup [:create_platform]

    test "lists all platforms", %{conn: conn, platform: platform} do
      {:ok, _index_live, html} = live(conn, Routes.platform_index_path(conn, :index))

      assert html =~ "Listing Platforms"
      assert html =~ platform.machine
    end

    test "saves new platform", %{conn: conn} do
      {:ok, index_live, _html} = live(conn, Routes.platform_index_path(conn, :index))

      assert index_live |> element("a", "New Platform") |> render_click() =~
               "New Platform"

      assert_patch(index_live, Routes.platform_index_path(conn, :new))

      assert index_live
             |> form("#platform-form", platform: @invalid_attrs)
             |> render_change() =~ "can&apos;t be blank"

      {:ok, _, html} =
        index_live
        |> form("#platform-form", platform: @create_attrs)
        |> render_submit()
        |> follow_redirect(conn, Routes.platform_index_path(conn, :index))

      assert html =~ "Platform created successfully"
      assert html =~ "some machine"
    end

    test "updates platform in listing", %{conn: conn, platform: platform} do
      {:ok, index_live, _html} = live(conn, Routes.platform_index_path(conn, :index))

      assert index_live |> element("#platform-#{platform.id} a", "Edit") |> render_click() =~
               "Edit Platform"

      assert_patch(index_live, Routes.platform_index_path(conn, :edit, platform))

      assert index_live
             |> form("#platform-form", platform: @invalid_attrs)
             |> render_change() =~ "can&apos;t be blank"

      {:ok, _, html} =
        index_live
        |> form("#platform-form", platform: @update_attrs)
        |> render_submit()
        |> follow_redirect(conn, Routes.platform_index_path(conn, :index))

      assert html =~ "Platform updated successfully"
      assert html =~ "some updated machine"
    end

    test "deletes platform in listing", %{conn: conn, platform: platform} do
      {:ok, index_live, _html} = live(conn, Routes.platform_index_path(conn, :index))

      assert index_live |> element("#platform-#{platform.id} a", "Delete") |> render_click()
      refute has_element?(index_live, "#platform-#{platform.id}")
    end
  end

  describe "Show" do
    setup [:create_platform]

    test "displays platform", %{conn: conn, platform: platform} do
      {:ok, _show_live, html} = live(conn, Routes.platform_show_path(conn, :show, platform))

      assert html =~ "Show Platform"
      assert html =~ platform.machine
    end

    test "updates platform within modal", %{conn: conn, platform: platform} do
      {:ok, show_live, _html} = live(conn, Routes.platform_show_path(conn, :show, platform))

      assert show_live |> element("a", "Edit") |> render_click() =~
               "Edit Platform"

      assert_patch(show_live, Routes.platform_show_path(conn, :edit, platform))

      assert show_live
             |> form("#platform-form", platform: @invalid_attrs)
             |> render_change() =~ "can&apos;t be blank"

      {:ok, _, html} =
        show_live
        |> form("#platform-form", platform: @update_attrs)
        |> render_submit()
        |> follow_redirect(conn, Routes.platform_show_path(conn, :show, platform))

      assert html =~ "Platform updated successfully"
      assert html =~ "some updated machine"
    end
  end
end
