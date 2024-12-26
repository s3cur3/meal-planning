defmodule Mp.Repo do
  use Ecto.Repo,
    otp_app: :mp,
    adapter: Ecto.Adapters.Postgres

  def fetch(module, attrs) do
    case get(module, attrs) do
      nil -> {:error, :not_found}
      meal -> {:ok, meal}
    end
  end
end
