defmodule Mp.Meals.Meal do
  use Mp.Schema
  import Ecto.Changeset

  alias Mp.Accounts.User

  typed_schema "meals" do
    field :name, :string, null: false
    field :url, :string
    field :images, {:array, :string}, default: []
    field :desired_frequency_days, :integer, default: 30

    belongs_to :user, User

    timestamps()
  end

  @doc false
  def changeset(meal, attrs) do
    meal
    |> cast(attrs, [:name, :url, :images, :desired_frequency_days, :user_id])
    |> validate_required([:name, :images, :user_id])
  end

  defimpl Phoenix.Param do
    def to_param(struct) do
      Mp.Utils.Slug.url_slug(struct)
    end
  end
end
