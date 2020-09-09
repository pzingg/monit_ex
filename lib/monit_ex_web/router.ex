defmodule MonitExWeb.Router do
  use MonitExWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, {MonitExWeb.LayoutView, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :collector do
    plug :auth
    plug :accepts, ["xml"]

    plug Plug.Parsers,
      parsers: [{:xml, xml_decoder: {Quinn, :parse, []}}]
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/collector", MonitExWeb do
    pipe_through :collector

    post "/", CollectorController, :create
  end

  scope "/", MonitExWeb do
    pipe_through :browser

    live "/servers", ServerLive.Index, :index
    live "/servers/new", ServerLive.Index, :new
    live "/servers/:id/edit", ServerLive.Index, :edit
    live "/servers/:id", ServerLive.Show, :show
    live "/servers/:id/show/edit", ServerLive.Show, :edit

    live "/platforms", PlatformLive.Index, :index
    live "/platforms/new", PlatformLive.Index, :new
    live "/platforms/:id/edit", PlatformLive.Index, :edit
    live "/platforms/:id", PlatformLive.Show, :show
    live "/platforms/:id/show/edit", PlatformLive.Show, :edit

    live "/systems", SystemLive.Index, :index
    live "/systems/new", SystemLive.Index, :new
    live "/systems/:id/edit", SystemLive.Index, :edit
    live "/systems/:id", SystemLive.Show, :show
    live "/systems/:id/show/edit", SystemLive.Show, :edit

    live "/processes", ProcessLive.Index, :index
    live "/processes/new", ProcessLive.Index, :new
    live "/processes/:id/edit", ProcessLive.Index, :edit
    live "/processes/:id", ProcessLive.Show, :show
    live "/processes/:id/show/edit", ProcessLive.Show, :edit

    get "/", PageController, :index
  end

  # Other scopes may use custom stacks.
  # scope "/api", MonitExWeb do
  #   pipe_through :api
  # end

  # Enables LiveDashboard only for development
  #
  # If you want to use the LiveDashboard in production, you should put
  # it behind authentication and allow only admins to access it.
  # If your application does not have an admins-only section yet,
  # you can use Plug.BasicAuth to set up some basic authentication
  # as long as you are also using SSL (which you should anyway).
  if Mix.env() in [:dev, :test] do
    import Phoenix.LiveDashboard.Router

    scope "/" do
      pipe_through :browser
      live_dashboard "/dashboard", metrics: MonitExWeb.Telemetry
    end
  end

  defp auth(conn, _opts) do
    with {username, password} <- Plug.BasicAuth.parse_basic_auth(conn) do
      conn
      |> assign(:basic_auth_credentials, {username, password})
    else
      :error -> conn |> Plug.BasicAuth.request_basic_auth() |> halt()
    end
  end
end
