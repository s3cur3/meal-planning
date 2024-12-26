defmodule Mp.Repo.Migrations.CreateSuggestions do
  use Ecto.Migration

  def change do
    create table(:suggestions) do
      add :meal_id, references(:meals, on_delete: :nothing), null: false
      add :user_id, references(:users, on_delete: :nothing), null: false
      add :suggested_at, :utc_datetime_usec, null: false

      timestamps()
    end

    create index(:suggestions, [:meal_id, :suggested_at])
    create index(:suggestions, [:user_id, :suggested_at])
  end
end
