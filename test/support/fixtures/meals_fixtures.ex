defmodule Mp.MealsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Mp.Meals` context.
  """

  @doc """
  Generate a meal.
  """
  def meal_fixture(attrs \\ %{}) do
    {:ok, meal} =
      attrs
      |> Enum.into(%{
        desired_frequency_days: 42,
        images: ["option1", "option2"],
        name: "some name",
        url: "some url"
      })
      |> Mp.Meals.create_meal()

    meal
  end
end
