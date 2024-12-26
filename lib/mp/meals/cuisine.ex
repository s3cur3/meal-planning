defmodule Mp.Meals.Cuisine do
  use Mp.Schema
  import Ecto.Changeset

  schema "cuisines" do
    field :name, :string

    timestamps()
  end

  @doc false
  def changeset(cuisine, attrs) do
    cuisine
    |> cast(attrs, [:name])
    |> validate_required([:name])
  end
end
