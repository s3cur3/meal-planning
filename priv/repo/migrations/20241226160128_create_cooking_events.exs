defmodule Mp.Repo.Migrations.CreateCookingEvents do
  use Ecto.Migration

  def change do
    create table(:cooking_events) do
      add :meal, references(:meals, on_delete: :nothing)
      add :user, references(:users, on_delete: :nothing)

      timestamps()
    end

    create index(:cooking_events, [:meal])
    create index(:cooking_events, [:user])
  end
end
