defmodule Mp.Repo.Migrations.CreateSuggestions do
  use Ecto.Migration

  def change do
    create table(:suggestions) do
      add :array, references(:meals, on_delete: :nothing)
      add :user, references(:users, on_delete: :nothing)

      timestamps()
    end

    create index(:suggestions, [:array])
    create index(:suggestions, [:user])
  end
end
