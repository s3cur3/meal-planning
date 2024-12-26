defmodule Mp.Meals.MealCuisines do
  use Mp.Schema
  import Ecto.Changeset

  schema "meal_cuisines" do
    field :meal, :id
    field :cuisine, :id

    timestamps()
  end

  @doc false
  def changeset(meal_cuisines, attrs) do
    meal_cuisines
    |> cast(attrs, [])
    |> validate_required([])
  end
end
