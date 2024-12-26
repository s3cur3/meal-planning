defmodule Mp.Meals.Meal do
  use Mp.Schema
  import Ecto.Changeset
  alias Mp.Users.User

  schema "meals" do
    field :name, :string
    field :url, :string
    field :images, {:array, :string}
    field :desired_frequency_days, :integer

    belongs_to :user, User

    timestamps()
  end

  @doc false
  def changeset(meal, attrs) do
    meal
    |> cast(attrs, [:name, :url, :images, :desired_frequency_days])
    |> validate_required([:name, :url, :images, :desired_frequency_days])
  end
end
