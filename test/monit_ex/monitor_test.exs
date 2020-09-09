defmodule MonitEx.MonitorTest do
  use MonitEx.DataCase

  alias MonitEx.Monitor
  alias MonitEx.Monitor.Server

  require Logger

  @valid_server_attrs %{
    id: "84ef6387f1ca5e1dc8b4f8565620ffa6",
    address: "some address",
    hostname: "some hostname",
    monit_version: "some monit_version",
    uptime: 42
  }

  def server_fixture(attrs \\ %{}) do
    {:ok, server} =
      attrs
      |> Enum.into(@valid_server_attrs)
      |> Monitor.create_server()

    server
  end

  describe "servers" do
    @update_attrs %{
      address: "some updated address",
      hostname: "some updated hostname",
      monit_version: "some updated monit_version",
      uptime: 43
    }
    @invalid_attrs %{address: nil, hostname: nil, monit_version: nil, uptime: nil}

    test "list_servers/0 returns all servers" do
      server = server_fixture()
      assert Monitor.list_servers() == [server]
    end

    test "get_server!/1 returns the server with given id" do
      server = server_fixture()
      assert Monitor.get_server!(server.id) == server
    end

    test "create_server/1 with valid data creates a server" do
      assert {:ok, %Server{} = server} = Monitor.create_server(@valid_server_attrs)
      assert server.address == "some address"
      assert server.hostname == "some hostname"
      assert server.monit_version == "some monit_version"
      assert server.uptime == 42
    end

    test "create_server/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Monitor.create_server(@invalid_attrs)
    end

    test "update_server/2 with valid data updates the server" do
      server = server_fixture()
      assert {:ok, %Server{} = server} = Monitor.update_server(server, @update_attrs)
      assert server.address == "some updated address"
      assert server.hostname == "some updated hostname"
      assert server.monit_version == "some updated monit_version"
      assert server.uptime == 43
    end

    test "update_server/2 with invalid data returns error changeset" do
      server = server_fixture()
      assert {:error, %Ecto.Changeset{}} = Monitor.update_server(server, @invalid_attrs)
      assert server == Monitor.get_server!(server.id)
    end

    test "delete_server/1 deletes the server" do
      server = server_fixture()
      assert {:ok, %Server{}} = Monitor.delete_server(server)
      assert_raise Ecto.NoResultsError, fn -> Monitor.get_server!(server.id) end
    end

    test "change_server/1 returns a server changeset" do
      server = server_fixture()
      assert %Ecto.Changeset{} = Monitor.change_server(server)
    end
  end

  describe "platforms" do
    alias MonitEx.Monitor.Platform

    @valid_attrs %{
      server_id: "84ef6387f1ca5e1dc8b4f8565620ffa6",
      cpu: 42,
      machine: "some machine",
      memory: 42,
      name: "some name",
      release: "some release",
      swap: 42,
      version: "some version"
    }
    @update_attrs %{
      server_id: "84ef6387f1ca5e1dc8b4f8565620ffa6",
      cpu: 43,
      machine: "some updated machine",
      memory: 43,
      name: "some updated name",
      release: "some updated release",
      swap: 43,
      version: "some updated version"
    }
    @invalid_attrs %{
      server_id: nil,
      cpu: nil,
      machine: nil,
      memory: nil,
      name: nil,
      release: nil,
      swap: nil,
      version: nil
    }

    def platform_fixture(attrs \\ %{}) do
      _ = server_fixture()

      {:ok, platform} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Monitor.create_platform()

      platform
    end

    test "list_platforms/0 returns all platforms" do
      platform = platform_fixture()
      assert Monitor.list_platforms() == [platform]
    end

    test "get_platform!/1 returns the platform with given id" do
      platform = platform_fixture()
      assert Monitor.get_platform!(platform.id) == platform
    end

    test "create_platform/1 with valid data creates a platform" do
      _ = server_fixture()
      assert {:ok, %Platform{} = platform} = Monitor.create_platform(@valid_attrs)
      assert platform.cpu == 42
      assert platform.machine == "some machine"
      assert platform.memory == 42
      assert platform.name == "some name"
      assert platform.release == "some release"
      assert platform.swap == 42
      assert platform.version == "some version"
    end

    test "create_platform/1 with invalid data returns error changeset" do
      _ = server_fixture()
      assert {:error, %Ecto.Changeset{}} = Monitor.create_platform(@invalid_attrs)
    end

    test "update_platform/2 with valid data updates the platform" do
      platform = platform_fixture()
      assert {:ok, %Platform{} = platform} = Monitor.update_platform(platform, @update_attrs)
      assert platform.cpu == 43
      assert platform.machine == "some updated machine"
      assert platform.memory == 43
      assert platform.name == "some updated name"
      assert platform.release == "some updated release"
      assert platform.swap == 43
      assert platform.version == "some updated version"
    end

    test "update_platform/2 with invalid data returns error changeset" do
      platform = platform_fixture()
      assert {:error, %Ecto.Changeset{}} = Monitor.update_platform(platform, @invalid_attrs)
      assert platform == Monitor.get_platform!(platform.id)
    end

    test "delete_platform/1 deletes the platform" do
      platform = platform_fixture()
      assert {:ok, %Platform{}} = Monitor.delete_platform(platform)
      assert_raise Ecto.NoResultsError, fn -> Monitor.get_platform!(platform.id) end
    end

    test "change_platform/1 returns a platform changeset" do
      platform = platform_fixture()
      assert %Ecto.Changeset{} = Monitor.change_platform(platform)
    end
  end

  describe "systems" do
    alias MonitEx.Monitor.System

    @initial_data %{
      date: 42,
      load_avg01: 120.5,
      load_avg05: 120.5,
      load_avg15: 120.5
    }
    @update_data %{
      date: 43,
      load_avg01: 456.7,
      load_avg05: 456.7,
      load_avg15: 456.7
    }
    @valid_attrs %{
      server_id: "84ef6387f1ca5e1dc8b4f8565620ffa6",
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
      server_id: "84ef6387f1ca5e1dc8b4f8565620ffa6",
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
      server_id: nil,
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

    def system_fixture(attrs \\ %{}) do
      _ = server_fixture()

      {:ok, system} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Monitor.create_system()

      system
    end

    test "list_systems/0 returns all systems" do
      system = system_fixture()
      assert Monitor.list_systems() == [system]
    end

    test "get_system!/1 returns the system with given id" do
      system = system_fixture()
      assert Monitor.get_system!(system.id) == system
    end

    test "create_system/1 with valid data creates a system" do
      _ = server_fixture()

      assert {:ok, %System{} = system} =
               Monitor.create_system_with_data(@valid_attrs, @initial_data)

      assert system.server_id == "84ef6387f1ca5e1dc8b4f8565620ffa6"
      assert system.date == 42
      assert system.load_avg01 == 120.5
      assert system.load_avg05 == 120.5
      assert system.load_avg15 == 120.5
      assert system.monitor == 42
      assert system.monitor_mode == 42
      assert system.name == "some name"
      assert system.pending_action == 42
      assert system.status == "some status"
      assert system.status_hint == 42
      assert !is_nil(system.data)
      assert hd(system.data.series) == @initial_data
    end

    test "create_system/1 with invalid data returns error changeset" do
      _ = server_fixture()
      assert {:error, %Ecto.Changeset{}} = Monitor.create_system(@invalid_attrs)
    end

    test "update_system/2 with valid data updates the system" do
      system = system_fixture()

      assert {:ok, %System{} = system} =
               Monitor.update_system_with_data(system, @update_attrs, @update_data)

      assert system.server_id == "84ef6387f1ca5e1dc8b4f8565620ffa6"
      assert system.date == 43
      assert system.load_avg01 == 456.7
      assert system.load_avg05 == 456.7
      assert system.load_avg15 == 456.7
      assert system.monitor == 43
      assert system.monitor_mode == 43
      assert system.name == "some updated name"
      assert system.pending_action == 43
      assert system.status == "some updated status"
      assert system.status_hint == 43
      assert !is_nil(system.data)
      assert hd(system.data.series) == @update_data
    end

    test "update_system/2 with invalid data returns error changeset" do
      system = system_fixture()
      assert {:error, %Ecto.Changeset{}} = Monitor.update_system(system, @invalid_attrs)
      assert system == Monitor.get_system!(system.id)
    end

    test "delete_system/1 deletes the system" do
      system = system_fixture()
      assert {:ok, %System{}} = Monitor.delete_system(system)
      assert_raise Ecto.NoResultsError, fn -> Monitor.get_system!(system.id) end
    end

    test "change_system/1 returns a system changeset" do
      system = system_fixture()
      assert %Ecto.Changeset{} = Monitor.change_system(system)
    end
  end

  describe "processes" do
    alias MonitEx.Monitor.Process

    @valid_attrs %{
      server_id: "84ef6387f1ca5e1dc8b4f8565620ffa6",
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
      server_id: "84ef6387f1ca5e1dc8b4f8565620ffa6",
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
      server_id: nil,
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

    def process_fixture(attrs \\ %{}) do
      _ = server_fixture()

      {:ok, process} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Monitor.create_process()

      process
    end

    test "list_processes/0 returns all processes" do
      process = process_fixture()
      assert Monitor.list_processes() == [process]
    end

    test "get_process!/1 returns the process with given id" do
      process = process_fixture()
      assert Monitor.get_process!(process.id) == process
    end

    test "create_process/1 with valid data creates a process" do
      _ = server_fixture()
      assert {:ok, %Process{} = process} = Monitor.create_process(@valid_attrs)
      assert process.children == 42
      assert process.cpu_percent == 120.5
      assert process.date == 42
      assert process.memory_kilobyte == 42
      assert process.memory_percent == 120.5
      assert process.monitor == 42
      assert process.monitor_mode == 42
      assert process.name == "some name"
      assert process.pending_action == 42
      assert process.pid == 42
      assert process.ppid == 42
      assert process.status == "some status"
      assert process.status_hint == 42
      assert process.uptime == 42
    end

    test "create_process/1 with invalid data returns error changeset" do
      _ = server_fixture()
      assert {:error, %Ecto.Changeset{}} = Monitor.create_process(@invalid_attrs)
    end

    test "update_process/2 with valid data updates the process" do
      process = process_fixture()
      assert {:ok, %Process{} = process} = Monitor.update_process(process, @update_attrs)
      assert process.children == 43
      assert process.cpu_percent == 456.7
      assert process.date == 43
      assert process.memory_kilobyte == 43
      assert process.memory_percent == 456.7
      assert process.monitor == 43
      assert process.monitor_mode == 43
      assert process.name == "some updated name"
      assert process.pending_action == 43
      assert process.pid == 43
      assert process.ppid == 43
      assert process.status == "some updated status"
      assert process.status_hint == 43
      assert process.uptime == 43
    end

    test "update_process/2 with invalid data returns error changeset" do
      process = process_fixture()
      assert {:error, %Ecto.Changeset{}} = Monitor.update_process(process, @invalid_attrs)
      assert process == Monitor.get_process!(process.id)
    end

    test "delete_process/1 deletes the process" do
      process = process_fixture()
      assert {:ok, %Process{}} = Monitor.delete_process(process)
      assert_raise Ecto.NoResultsError, fn -> Monitor.get_process!(process.id) end
    end

    test "change_process/1 returns a process changeset" do
      process = process_fixture()
      assert %Ecto.Changeset{} = Monitor.change_process(process)
    end
  end
end
