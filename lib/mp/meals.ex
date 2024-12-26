defmodule Mp.Meals do
  @moduledoc """
  The Meals context.
  """

  import Ecto.Query, warn: false

  alias Mp.Accounts.User
  alias Mp.Meals.Meal
  alias Mp.Repo
  alias Mp.Utils
  alias Mp.Utils.Slug

  @doc """
  Returns the list of meals that belong to the given user.

  ## Examples

      iex> list_meals(%User{})
      [%Meal{}, ...]

  """
  def list_meals(%User{} = user) do
    Repo.all(from(m in Meal, where: m.user_id == ^user.id))
  end

  @doc """
  Gets a single meal.

  Raises `Ecto.NoResultsError` if the Meal does not exist.

  ## Examples

      iex> get_meal!(123)
      %Meal{}

      iex> get_meal!(456)
      ** (Ecto.NoResultsError)

  """
  def get_meal!(id), do: Repo.get!(Meal, id)

  def get_meal_by_slug_or_id(id) when is_integer(id), do: Repo.fetch(Meal, id)

  def get_meal_by_slug_or_id!(slug_or_id) when is_binary(slug_or_id) do
    case Slug.parse_slug_or_id(slug_or_id) do
      {:ok, id} -> Repo.fetch(Meal, id)
      {:error, :invalid_id} -> {:error, :invalid_id}
    end
  end

  def owned_by?(%Meal{user_id: user_id}, %User{id: user_id}), do: user_id == user_id

  @doc """
  Creates a meal.

  ## Examples

      iex> create_meal(%{field: value})
      {:ok, %Meal{}}

      iex> create_meal(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_meal(attrs, %User{} = user) do
    full_attrs = Map.put(attrs, :user_id, user.id) |> Utils.Map.string_keys()

    %Meal{}
    |> Meal.changeset(full_attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a meal.

  ## Examples

      iex> update_meal(meal, %{field: new_value})
      {:ok, %Meal{}}

      iex> update_meal(meal, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_meal(%Meal{} = meal, attrs) do
    meal
    |> Meal.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a meal.

  ## Examples

      iex> delete_meal(meal)
      {:ok, %Meal{}}

      iex> delete_meal(meal)
      {:error, %Ecto.Changeset{}}

  """
  def delete_meal(%Meal{} = meal) do
    Repo.delete(meal)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking meal changes.

  ## Examples

      iex> change_meal(meal)
      %Ecto.Changeset{data: %Meal{}}

  """
  def change_meal(%Meal{} = meal, attrs \\ %{}) do
    Meal.changeset(meal, attrs)
  end
end
