defmodule Mp.Repo.Migrations.CreateCookingEvents do
  use Ecto.Migration

  def change do
    create table(:cooking_events) do
      add :meal_id, references(:meals, on_delete: :nothing), null: false
      add :user_id, references(:users, on_delete: :nothing), null: false

      timestamps()
    end

    create index(:cooking_events, [:meal_id])
    create index(:cooking_events, [:user_id])
  end
end
