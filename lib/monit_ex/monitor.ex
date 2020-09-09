defmodule MonitEx.Monitor do
  @moduledoc """
  The Monitor context.
  """

  import Ecto.Query, warn: false
  alias MonitEx.Repo

  require Logger

  alias MonitEx.Monitor.Server

  @doc """
  Returns the list of servers.

  ## Examples

      iex> list_servers()
      [%Server{}, ...]

  """
  def list_servers do
    Repo.all(Server)
  end

  @doc """
  Gets a single server.

  Raises `Ecto.NoResultsError` if the Server does not exist.

  ## Examples

      iex> get_server!(123)
      %Server{}

      iex> get_server!(456)
      ** (Ecto.NoResultsError)

  """
  def get_server!(id), do: Repo.get!(Server, id)

  @doc """
  Creates a server.

  ## Examples

      iex> create_server(%{field: value})
      {:ok, %Server{}}

      iex> create_server(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_server(attrs \\ %{}) do
    %Server{}
    |> Server.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a server.

  ## Examples

      iex> update_server(server, %{field: new_value})
      {:ok, %Server{}}

      iex> update_server(server, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_server(%Server{} = server, attrs) do
    server
    |> Server.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a server.

  ## Examples

      iex> delete_server(server)
      {:ok, %Server{}}

      iex> delete_server(server)
      {:error, %Ecto.Changeset{}}

  """
  def delete_server(%Server{} = server) do
    Repo.delete(server)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking server changes.

  ## Examples

      iex> change_server(server)
      %Ecto.Changeset{data: %Server{}}

  """
  def change_server(%Server{} = server, attrs \\ %{}) do
    Server.changeset(server, attrs)
  end

  alias MonitEx.Monitor.Platform

  @doc """
  Returns the list of platforms.

  ## Examples

      iex> list_platforms()
      [%Platform{}, ...]

  """
  def list_platforms do
    Repo.all(Platform)
  end

  @doc """
  Gets a single platform.

  Raises `Ecto.NoResultsError` if the Platform does not exist.

  ## Examples

      iex> get_platform!(123)
      %Platform{}

      iex> get_platform!(456)
      ** (Ecto.NoResultsError)

  """
  def get_platform!(id), do: Repo.get!(Platform, id)

  def get_platform_by_server_id_and_name(server_id, name) do
    Platform
    |> where([p], p.server_id == ^server_id and p.name == ^name)
    |> Repo.one()
  end

  @doc """
  Creates a platform.

  ## Examples

      iex> create_platform(%{field: value})
      {:ok, %Platform{}}

      iex> create_platform(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_platform(attrs \\ %{}) do
    %Platform{}
    |> Platform.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a platform.

  ## Examples

      iex> update_platform(platform, %{field: new_value})
      {:ok, %Platform{}}

      iex> update_platform(platform, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_platform(%Platform{} = platform, attrs) do
    platform
    |> Platform.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a platform.

  ## Examples

      iex> delete_platform(platform)
      {:ok, %Platform{}}

      iex> delete_platform(platform)
      {:error, %Ecto.Changeset{}}

  """
  def delete_platform(%Platform{} = platform) do
    Repo.delete(platform)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking platform changes.

  ## Examples

      iex> change_platform(platform)
      %Ecto.Changeset{data: %Platform{}}

  """
  def change_platform(%Platform{} = platform, attrs \\ %{}) do
    Platform.changeset(platform, attrs)
  end

  alias MonitEx.Monitor.System

  @doc """
  Returns the list of systems.

  ## Examples

      iex> list_systems()
      [%System{}, ...]

  """
  def list_systems do
    Repo.all(System)
  end

  @doc """
  Gets a single system.

  Raises `Ecto.NoResultsError` if the System does not exist.

  ## Examples

      iex> get_system!(123)
      %System{}

      iex> get_system!(456)
      ** (Ecto.NoResultsError)

  """
  def get_system!(id), do: Repo.get!(System, id)

  def get_system_by_server_id_and_name(server_id, name) do
    System
    |> where([p], p.server_id == ^server_id and p.name == ^name)
    |> Repo.one()
  end

  @doc """
  Creates a system.

  ## Examples

      iex> create_system(%{field: value})
      {:ok, %System{}}

      iex> create_system(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_system(attrs \\ %{}) do
    %System{}
    |> System.changeset(attrs)
    |> Repo.insert()
  end

  def create_system_with_data(attrs, data) do
    create_system(attrs |> Map.put(:data, %{"series" => [data]}))
  end

  @doc """
  Updates a system.

  ## Examples

      iex> update_system(system, %{field: new_value})
      {:ok, %System{}}

      iex> update_system(system, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_system(%System{} = system, attrs) do
    system
    |> System.changeset(attrs)
    |> Repo.update()
  end

  def update_system_with_data(%System{} = system, attrs, data) do
    new_series = prepend_data(system.data["series"], data)
    update_system(system, attrs |> Map.put(:data, %{"series" => new_series}))
  end

  @doc """
  Deletes a system.

  ## Examples

      iex> delete_system(system)
      {:ok, %System{}}

      iex> delete_system(system)
      {:error, %Ecto.Changeset{}}

  """
  def delete_system(%System{} = system) do
    Repo.delete(system)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking system changes.

  ## Examples

      iex> change_system(system)
      %Ecto.Changeset{data: %System{}}

  """
  def change_system(%System{} = system, attrs \\ %{}) do
    System.changeset(system, attrs)
  end

  alias MonitEx.Monitor.Process

  @doc """
  Returns the list of processes.

  ## Examples

      iex> list_processes()
      [%Process{}, ...]

  """
  def list_processes do
    Repo.all(Process)
  end

  @doc """
  Gets a single process.

  Raises `Ecto.NoResultsError` if the Process does not exist.

  ## Examples

      iex> get_process!(123)
      %Process{}

      iex> get_process!(456)
      ** (Ecto.NoResultsError)

  """
  def get_process!(id), do: Repo.get!(Process, id)

  def get_process_by_server_id_and_name(server_id, name) do
    Process
    |> where([p], p.server_id == ^server_id and p.name == ^name)
    |> Repo.one()
  end

  @doc """
  Creates a process.

  ## Examples

      iex> create_process(%{field: value})
      {:ok, %Process{}}

      iex> create_process(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_process(attrs \\ %{}) do
    %Process{}
    |> Process.changeset(attrs)
    |> Repo.insert()
  end

  def create_process_with_data(attrs, data) do
    create_process(attrs |> Map.put(:data, %{"series" => [data]}))
  end

  @doc """
  Updates a process.

  ## Examples

      iex> update_process(process, %{field: new_value})
      {:ok, %Process{}}

      iex> update_process(process, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_process(%Process{} = process, attrs) do
    process
    |> Process.changeset(attrs)
    |> Repo.update()
  end

  def update_process_with_data(%Process{} = process, attrs, data) do
    new_series = prepend_data(process.data["series"], data)
    update_process(process, attrs |> Map.put(:data, %{"series" => new_series}))
  end

  @doc """
  Deletes a process.

  ## Examples

      iex> delete_process(process)
      {:ok, %Process{}}

      iex> delete_process(process)
      {:error, %Ecto.Changeset{}}

  """
  def delete_process(%Process{} = process) do
    Repo.delete(process)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking process changes.

  ## Examples

      iex> change_process(process)
      %Ecto.Changeset{data: %Process{}}

  """
  def change_process(%Process{} = process, attrs \\ %{}) do
    Process.changeset(process, attrs)
  end

  def collect_data(monit_map, _credentials) do
    with %{name: :monit, attr: attrs, value: monit} <- monit_map do
      upsert(attrs, monit)
    else
      _ ->
        _ = Logger.error("Monitor.collect_data: invalid xml data")

        {:error, {:bad_request, "Invalid XML data"}}
    end
  end

  # See https://github.com/arnaudsj/monit/blob/master/xml.c
  @example """
  %{attr: [
      id: "84ef6387f1ca5e1dc8b4f8565620ffa6",
      incarnation: "1599520662",
      version: "5.16"
    ], name: :monit, value: [
    %{attr: [], name: :server, value: [
      %{attr: [], name: :uptime, value: ["18751"]},
      %{attr: [], name: :poll, value: ["2812"]},
        %{attr: [], name: :ssl, value: ["0"]}
      ]},
      %{attr: [], name: :credentials, value: [
        %{attr: [], name: :username, value: ["admin"]},
        %{attr: [], name: :password, value: ["monit"]}
      ]}
    ]},
    %{attr: [], name: :platform, value: [
      %{attr: [], name: :name, value: ["Linux"]},
      %{attr: [], name: :release, value: ["4.4.0-189-generic"]},
      %{attr: [], name: :version, value: ["#219-Ubuntu SMP Tue Aug 11 12:26:50 UTC 2020"]},
      %{attr: [], name: :machine, value: ["x86_64"]},
      %{attr: [], name: :cpu, value: ["8"]},
      %{attr: [], name: :memory, value: ["16290404"]},
      %{attr: [], name: :swap, value: ["33269756"]}
    ]},
    %{attr: [], name: :services, value: [
      %{attr: [name: "pzingg-3520"], name: :service, value: [
        %{attr: [], name: :type, value: ["5"]},
        %{attr: [], name: :collected_sec, value: ["1599537225"]},
        %{attr: [], name: :collected_usec, value: ["981441"]},
        %{attr: [], name: :status, value: ["0"]},
        %{attr: [], name: :status_hint, value: ["0"]},
        %{attr: [], name: :monitor, value: ["1"]},
        %{attr: [], name: :monitormode, value: ["0"]},
        %{attr: [], name: :pendingaction, value: ["0"]},
        %{attr: [], name: :system, value: [
          %{attr: [], name: :load, value: [
            %{attr: [], name: :avg01, value: ["0.98"]},
            %{attr: [], name: :avg05, value: ["0.57"]},
            %{attr: [], name: :avg15, value: ["0.36"]}
          ]},
          %{attr: [], name: :cpu, value: [
            %{attr: [], name: :user, value: ["4.2"]},
            %{attr: [], name: :system, value: ["1.1"]},
            %{attr: [], name: :wait, value: ["0.2"]}
          ]},
          %{attr: [], name: :memory, value: [
            %{attr: [], name: :percent, value: ["19.9"]},
            %{attr: [], name: :kilobyte, value: ["3244588"]}
          ]},
          %{attr: [], name: :swap, value: [
            %{attr: [], name: :percent, value: ["0.0"]},
            %{attr: [], name: :kilobyte, value: ["0"]}
          ]}
        ]}
      ]}
    ]},
    %{attr: [], name: :servicegroups, value: []}
  ]}
  """

  # See bitmask values in event.h, and messages in event.c
  @status_messages [
    # 0x1 - bit 0
    "Checksum failed",
    "Resource limit matched",
    "Timeout",
    "Timestamp failed",
    "Size failed",
    "Connection failed",
    "Permission failed",
    "UID failed",
    # 0x100 - bit 8
    "GID failed",
    "Does not exist",
    "Invalid type",
    "Data access error",
    "Execution failed",
    "Filesystem flags failed",
    "ICMP failed",
    "Content failed",
    # 0x10000 - bit 16
    "Monit instance failed",
    "Action done",
    "PID failed",
    "PPID failed",
    # 0x100000 - bit 20
    "Heartbeat failed"
  ]

  def decode_status(status) do
    bm = %Bitmap.Integer{data: String.to_integer(status), size: length(@status_messages)}

    {_size, errors} =
      @status_messages
      |> Enum.reduce({0, []}, fn message, {i, acc} ->
        if Bitmap.Integer.set?(bm, i) do
          {i + 1, [message | acc]}
        else
          {i + 1, acc}
        end
      end)

    if Enum.empty?(errors) do
      "OK"
    else
      Enum.reverse(errors) |> Enum.join(", ")
    end
  end

  defp get_elements_by_name(elem_list, name) do
    Enum.filter(elem_list, fn %{name: elem_name} -> elem_name == name end)
  end

  defp get_element_by_name(elem_list, name) do
    get_elements_by_name(elem_list, name) |> hd()
  end

  defp get_value(elem_list, name, default \\ "") do
    case get_elements_by_name(elem_list, name) do
      [elem] -> get_elem_value(elem, default)
      _ -> default
    end
  end

  defp get_value_in(elem_list, path, default \\ "")

  defp get_value_in(_elem_list, [], default), do: default

  defp get_value_in(elem_list, [name], default) do
    get_value(elem_list, name, default)
  end

  defp get_value_in(elem_list, [head | tail], default) do
    case get_elements_by_name(elem_list, head) do
      [%{value: head_elem}] -> get_value_in(head_elem, tail, default)
      _ -> default
    end
  end

  defp get_elem_value(%{value: [val]}, _default) when not is_map(val), do: val

  defp get_elem_value(_, default), do: default

  defp upsert(attrs, monit) do
    monit_id = Keyword.fetch!(attrs, :id)
    monit_version = Keyword.fetch!(attrs, :version)
    %{value: server} = get_element_by_name(monit, :server)

    server_attrs = %{
      id: monit_id,
      monit_version: monit_version,
      hostname: get_value(server, :localhostname),
      uptime: get_value(server, :uptime),
      address: get_value(server, :address)
    }

    case %Server{}
         |> Server.changeset(server_attrs)
         |> Repo.insert(conflict_target: :id, on_conflict: {:replace_all_except, [:id]}) do
      {:ok, %Server{} = server} ->
        %{value: platform} = get_element_by_name(monit, :platform)
        upsert_platform(server, platform)

        %{value: services} = get_element_by_name(monit, :services)

        active_processes =
          get_elements_by_name(services, :service)
          |> Enum.map(&upsert_service(server, &1))
          |> Enum.map(fn
            {:ok, %Process{name: name}} -> name
            _ -> nil
          end)
          |> Enum.reject(&is_nil(&1))

        _ = Logger.debug("Monitor.upsert reporting services: #{inspect(active_processes)}")

        remove_old_services(server, active_processes)

        :ok

      {:error, changeset} ->
        _ = Logger.debug("Monitor.upsert Server insert FAILED #{inspect(changeset)}")

        {:error, {:internal_server_error, "Database error"}}
    end
  end

  def upsert_platform(%{id: server_id}, platform) do
    name = get_value(platform, :name)

    platform_attrs = %{
      release: get_value(platform, :release),
      version: get_value(platform, :version),
      machine: get_value(platform, :machine),
      cpu: get_value(platform, :cpu),
      memory: get_value(platform, :memory),
      swap: get_value(platform, :swap)
    }

    case get_platform_by_server_id_and_name(server_id, name) do
      %Platform{} = platform ->
        update_platform(platform, platform_attrs)

      nil ->
        platform_attrs
        |> Map.merge(%{server_id: server_id, name: name})
        |> create_platform()
    end
  end

  def upsert_service(%{id: server_id}, %{attr: attrs, value: service}) do
    service_attrs = %{
      status: get_value(service, :status) |> decode_status(),
      status_hint: get_value(service, :status_hint),
      monitor: get_value(service, :monitor),
      monitor_mode: get_value(service, :monitormode),
      pending_action: get_value(service, :pendingaction)
    }

    service_name = Keyword.fetch!(attrs, :name)
    service_type = get_value(service, :type)

    case service_type do
      # TYPE_SYSTEM
      "5" ->
        system_data = %{
          date: get_value(service, :collected_sec),
          load_avg01: get_value_in(service, [:system, :load, :avg01]),
          load_avg05: get_value_in(service, [:system, :load, :avg05]),
          load_avg15: get_value_in(service, [:system, :load, :avg15]),
          cpu_user: get_value(service, [:system, :cpu, :user]),
          cpu_system: get_value(service, [:system, :cpu, :system]),
          cpu_wait: get_value(service, [:system, :cpu, :wait]),
          memory_percent: get_value(service, [:system, :memory, :percent]),
          memory_kilobyte: get_value(service, [:system, :memory, :kilobyte]),
          swap_percent: get_value(service, [:system, :swap, :percent]),
          swap_kilobyte: get_value(service, [:system, :swap, :kilobyte])
        }

        system_attrs =
          system_data
          |> Map.merge(service_attrs)

        case get_system_by_server_id_and_name(server_id, service_name) do
          %System{} = system ->
            update_system_with_data(system, system_attrs, system_data)

          nil ->
            system_attrs
            |> Map.merge(%{
              server_id: server_id,
              name: service_name
            })
            |> create_system_with_data(system_data)
        end

      # TYPE_PROCESS
      "3" ->
        process_data = %{
          date: get_value(service, :collected_sec),
          cpu_percent: get_value_in(service, [:cpu, :percenttotal]),
          memory_percent: get_value_in(service, [:memory, :percenttotal]),
          memory_kilobyte: get_value_in(service, [:memory, :kilobytetotal])
        }

        process_attrs = %{
          pid: get_value(service, :pid),
          ppid: get_value(service, :ppid),
          uptime: get_value(service, :uptime),
          children: get_value(service, :children)
        }

        process_attrs =
          process_attrs
          |> Map.merge(process_data)
          |> Map.merge(service_attrs)

        case get_process_by_server_id_and_name(server_id, service_name) do
          %Process{} = process ->
            update_process_with_data(process, process_attrs, process_data)

          nil ->
            process_attrs
            |> Map.merge(%{
              server_id: server_id,
              name: service_name
            })
            |> create_process_with_data(process_data)
        end

      _ ->
        _ = Logger.warn("Monitor.upsert_service ignoring service type #{service_type}")
        :ignore
    end
  end

  @max_data_size 10

  defp prepend_data(nil, new_data), do: [new_data]

  defp prepend_data(series, new_data) when is_list(series) do
    if length(series) < @max_data_size do
      [new_data | series]
    else
      [new_data | Enum.drop(series, -1)]
    end
  end

  defp prepend_data(other, _new_data), do: other

  defp remove_old_services(%Server{id: server_id}, service_list) do
    query =
      Process
      |> where([p], p.server_id == ^server_id)
      |> where([p], not (p.name in ^service_list))

    results =
      query
      # |> Repo.delete_all()
      |> Repo.all()

    _ = Logger.debug("removing processes(s) #{inspect(results)}")

    query =
      Server
      |> join(:inner, [s], p in assoc(s, :system))
      |> where([s, p], s.id == ^server_id)
      |> where([s, p], not (p.name in ^service_list))

    results =
      query
      # |> Repo.delete_all()
      |> Repo.all()

    _ = Logger.debug("removing server(s) #{inspect(results)}")
  end
end
