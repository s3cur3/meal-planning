defmodule Mp.Repo.Migrations.CreateMealCuisines do
  use Ecto.Migration

  def change do
    create table(:meal_cuisines) do
      add :meal, references(:meals, on_delete: :nothing)
      add :cuisine, references(:cuisines, on_delete: :nothing)

      timestamps()
    end

    create index(:meal_cuisines, [:meal])
    create index(:meal_cuisines, [:cuisine])
  end
end
