defmodule Mp.Meals.Suggestion do
  use Mp.Schema
  import Ecto.Changeset

  schema "suggestions" do
    field :array, :id
    field :user, :id

    timestamps()
  end

  @doc false
  def changeset(suggestion, attrs) do
    suggestion
    |> cast(attrs, [])
    |> validate_required([])
  end
end
