defmodule Mp.Meals.Cuisine do
  use Mp.Schema
  import Ecto.Changeset
  alias Mp.Accounts.User

  typed_schema "cuisines" do
    field :name, :string

    belongs_to :user, User

    timestamps()
  end

  @doc false
  def changeset(cuisine, attrs) do
    cuisine
    |> cast(attrs, [:name, :user_id])
    |> validate_required([:name, :user_id])
  end
end
