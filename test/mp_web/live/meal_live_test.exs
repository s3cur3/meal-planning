defmodule MpWeb.MealLiveTest do
  use MpWeb.ConnCase, async: true

  import Mp.MealsFixtures
  alias Mp.Utils.Number

  defp create_meal(context) do
    meal = meal_fixture(context)
    %{meal: meal}
  end

  describe "Index" do
    setup [:register_and_log_in_user]

    test "lists all this user's meals", %{conn: conn} = context do
      meal1 = meal_fixture(context)
      meal2 = meal_fixture(context)
      unowned_meal = meal_fixture()

      {:ok, _index_live, html} = live(conn, ~p"/meals")

      assert html =~ "Listing Meals"
      assert html =~ meal1.name
      assert html =~ meal2.name
      refute html =~ unowned_meal.name
    end

    test "saves new meal", %{conn: conn} do
      name = "My new meal #{Number.next_unique()}"

      conn
      |> visit(~p"/meals")
      |> click_link("New Meal")
      |> assert_has("h1", text: "New Meal")
      |> fill_in("Name", with: name)
      |> click_button("Save Meal")
      |> assert_has("h1", text: "Listing Meals")
      |> assert_has("td", text: name)
      |> assert_has("p", text: "Meal created successfully")
    end

    test "rejects new meal without a name", %{conn: conn} do
      conn
      |> visit(~p"/meals")
      |> click_link("New Meal")
      |> assert_has("h1", text: "New Meal")
      |> click_button("Save Meal")
      |> assert_has("p", text: "can't be blank")
    end

    test "updates meal in listing", %{conn: conn} = context do
      meal = meal_fixture(context)

      conn
      |> visit(~p"/meals")
      |> assert_has("td", text: meal.name)
      |> click_link("Edit")
      |> assert_has("h1", text: "Edit Meal")
      |> fill_in("Name", with: "some updated name")
      |> click_button("Save")
      |> assert_has("p", text: "Meal updated successfully")
      |> assert_has("h1", text: "Listing Meals")
      |> assert_has("td", text: "some updated name")
    end

    test "rejects meal update without a name", %{conn: conn} = context do
      meal = meal_fixture(context)

      conn
      |> visit(~p"/meals")
      |> assert_has("td", text: meal.name)
      |> click_link("Edit")
      |> assert_has("h1", text: "Edit Meal")
      |> fill_in("Name", with: "")
      |> click_button("Save")
      |> assert_has("p", text: "can't be blank")
    end

    test "deletes meal in listing", %{conn: conn} = context do
      meal = meal_fixture(context)
      {:ok, index_live, _html} = live(conn, ~p"/meals")

      assert index_live |> element("#meals-#{meal.id} a", "Delete") |> render_click()
      refute has_element?(index_live, "#meals-#{meal.id}")
    end
  end

  describe "Show" do
    setup [:register_and_log_in_user, :create_meal]

    test "displays meal", %{conn: conn, meal: meal} do
      {:ok, _show_live, html} = live(conn, ~p"/meals/#{meal}")

      assert html =~ "Show Meal"
      assert html =~ meal.name
    end

    test "updates meal within modal", %{conn: conn, meal: meal} do
      conn
      |> visit(~p"/meals/#{meal}")
      |> click_link("Edit")
      |> assert_has("h1", text: "Edit Meal")
      |> fill_in("Name", with: "some updated name")
      |> click_button("Save")
      |> assert_has("p", text: "Meal updated successfully")
      |> assert_has("h1", text: "some updated name")
    end
  end
end
