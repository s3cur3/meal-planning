defmodule Mp.Repo do
  use Ecto.Repo,
    otp_app: :mp,
    adapter: Ecto.Adapters.Postgres
end
