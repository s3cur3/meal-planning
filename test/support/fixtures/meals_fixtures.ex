defmodule Mp.MealsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Mp.Meals` context.
  """

  alias Mp.Accounts.User
  alias Mp.AccountsFixtures
  alias Mp.Utils.Number

  @doc """
  Generate a meal.
  """
  def meal_fixture(attrs \\ %{})

  def meal_fixture(%User{} = user) do
    meal_fixture(%{user: user})
  end

  def meal_fixture(attrs) do
    user =
      case attrs[:user] do
        nil -> AccountsFixtures.user_fixture()
        %User{} = user -> user
      end

    {:ok, meal} =
      attrs
      |> Enum.into(%{
        desired_frequency_days: 42,
        images: ["option1", "option2"],
        name: "Meal name #{Number.next_unique()}"
      })
      |> Mp.Meals.create_meal(user)

    meal
  end
end
