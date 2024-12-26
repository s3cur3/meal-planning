defmodule Mp.Meals.CookingEvent do
  use Mp.Schema
  import Ecto.Changeset

  schema "cooking_events" do
    field :meal, :id
    field :user, :id

    timestamps()
  end

  @doc false
  def changeset(cooking_event, attrs) do
    cooking_event
    |> cast(attrs, [])
    |> validate_required([])
  end
end
