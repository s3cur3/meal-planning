defmodule Mp.Repo.Migrations.CreateMealCuisines do
  use Ecto.Migration

  def change do
    create table(:meal_cuisines) do
      add :meal_id, references(:meals, on_delete: :nothing), null: false
      add :cuisine_id, references(:cuisines, on_delete: :nothing), null: false

      timestamps()
    end

    create index(:meal_cuisines, [:meal_id])
    create index(:meal_cuisines, [:cuisine_id])
  end
end
