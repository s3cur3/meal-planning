defmodule Mp.Repo.Migrations.CreateMeals do
  use Ecto.Migration

  def change do
    create table(:meals) do
      add :name, :string, null: false
      add :url, :string
      add :images, {:array, :string}, null: false
      add :desired_frequency_days, :integer, null: false

      add :user_id, references(:users, on_delete: :delete_all), null: false

      timestamps()
    end

    create index(:meals, [:user_id])
  end
end
