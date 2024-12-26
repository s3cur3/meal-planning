defmodule Mp.MealsTest do
  use Mp.DataCase

  alias Mp.Meals
  alias Mp.Meals.Meal
  alias Mp.AccountsFixtures

  describe "meals" do
    import Mp.MealsFixtures

    @invalid_attrs %{name: nil, url: nil, images: nil, desired_frequency_days: nil}

    test "list_meals/1 returns all a user's meals" do
      user = AccountsFixtures.user_fixture()
      other_user = AccountsFixtures.user_fixture()
      meal = meal_fixture(user)
      assert Meals.list_meals(user) == [meal]
      assert Meals.list_meals(other_user) == []
    end

    test "get_meal!/1 returns the meal with given id" do
      meal = meal_fixture()
      assert Meals.get_meal!(meal.id) == meal
    end

    test "create_meal/1 with valid data creates a meal" do
      user = AccountsFixtures.user_fixture()

      valid_attrs = %{
        name: "some name",
        url: "some url",
        images: ["option1", "option2"],
        desired_frequency_days: 42,
        user: user
      }

      assert {:ok, %Meal{} = meal} = Meals.create_meal(valid_attrs, user)
      assert meal.name == "some name"
      assert meal.url == "some url"
      assert meal.images == ["option1", "option2"]
      assert meal.desired_frequency_days == 42
      assert meal.user_id == user.id
    end

    test "create_meal/1 with invalid data returns error changeset" do
      user = AccountsFixtures.user_fixture()
      assert {:error, %Ecto.Changeset{}} = Meals.create_meal(@invalid_attrs, user)
    end

    test "update_meal/2 with valid data updates the meal" do
      meal = meal_fixture()

      update_attrs = %{
        name: "some updated name",
        url: "some updated url",
        images: ["option1"],
        desired_frequency_days: 43
      }

      assert {:ok, %Meal{} = meal} = Meals.update_meal(meal, update_attrs)
      assert meal.name == "some updated name"
      assert meal.url == "some updated url"
      assert meal.images == ["option1"]
      assert meal.desired_frequency_days == 43
    end

    test "update_meal/2 with invalid data returns error changeset" do
      meal = meal_fixture()
      assert {:error, %Ecto.Changeset{}} = Meals.update_meal(meal, @invalid_attrs)
      assert meal == Meals.get_meal!(meal.id)
    end

    test "delete_meal/1 deletes the meal" do
      meal = meal_fixture()
      assert {:ok, %Meal{}} = Meals.delete_meal(meal)
      assert_raise Ecto.NoResultsError, fn -> Meals.get_meal!(meal.id) end
    end

    test "change_meal/1 returns a meal changeset" do
      meal = meal_fixture()
      assert %Ecto.Changeset{} = Meals.change_meal(meal)
    end
  end
end
