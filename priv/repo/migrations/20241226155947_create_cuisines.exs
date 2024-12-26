defmodule Mp.Repo.Migrations.CreateCuisines do
  use Ecto.Migration

  def change do
    create table(:cuisines) do
      add :name, :string

      timestamps()
    end
  end
end
