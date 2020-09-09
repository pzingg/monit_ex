defmodule MonitEx.Repo do
  use Ecto.Repo,
    otp_app: :monit_ex,
    adapter: Ecto.Adapters.Postgres
end
