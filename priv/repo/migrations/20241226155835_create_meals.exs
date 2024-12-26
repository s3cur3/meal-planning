defmodule Mp.Repo.Migrations.CreateMeals do
  use Ecto.Migration

  def change do
    create table(:meals) do
      add :name, :string
      add :url, :string
      add :images, {:array, :string}
      add :desired_frequency_days, :integer

      add :user_id, references(:users, on_delete: :delete_all)

      timestamps()
    end
  end
end
