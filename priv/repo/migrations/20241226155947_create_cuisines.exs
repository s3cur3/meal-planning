defmodule Mp.Repo.Migrations.CreateCuisines do
  use Ecto.Migration

  def change do
    create table(:cuisines) do
      add :name, :string, null: false
      add :user_id, references(:users, on_delete: :delete_all), null: false

      timestamps()
    end

    create index(:cuisines, [:user_id])
  end
end
