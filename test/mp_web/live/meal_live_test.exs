defmodule MpWeb.MealLiveTest do
  use MpWeb.ConnCase

  import Phoenix.LiveViewTest
  import Mp.MealsFixtures

  @create_attrs %{name: "some name", url: "some url", images: ["option1", "option2"], desired_frequency_days: 42}
  @update_attrs %{name: "some updated name", url: "some updated url", images: ["option1"], desired_frequency_days: 43}
  @invalid_attrs %{name: nil, url: nil, images: [], desired_frequency_days: nil}

  defp create_meal(_) do
    meal = meal_fixture()
    %{meal: meal}
  end

  describe "Index" do
    setup [:create_meal]

    test "lists all meals", %{conn: conn, meal: meal} do
      {:ok, _index_live, html} = live(conn, ~p"/meals")

      assert html =~ "Listing Meals"
      assert html =~ meal.name
    end

    test "saves new meal", %{conn: conn} do
      {:ok, index_live, _html} = live(conn, ~p"/meals")

      assert index_live |> element("a", "New Meal") |> render_click() =~
               "New Meal"

      assert_patch(index_live, ~p"/meals/new")

      assert index_live
             |> form("#meal-form", meal: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert index_live
             |> form("#meal-form", meal: @create_attrs)
             |> render_submit()

      assert_patch(index_live, ~p"/meals")

      html = render(index_live)
      assert html =~ "Meal created successfully"
      assert html =~ "some name"
    end

    test "updates meal in listing", %{conn: conn, meal: meal} do
      {:ok, index_live, _html} = live(conn, ~p"/meals")

      assert index_live |> element("#meals-#{meal.id} a", "Edit") |> render_click() =~
               "Edit Meal"

      assert_patch(index_live, ~p"/meals/#{meal}/edit")

      assert index_live
             |> form("#meal-form", meal: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert index_live
             |> form("#meal-form", meal: @update_attrs)
             |> render_submit()

      assert_patch(index_live, ~p"/meals")

      html = render(index_live)
      assert html =~ "Meal updated successfully"
      assert html =~ "some updated name"
    end

    test "deletes meal in listing", %{conn: conn, meal: meal} do
      {:ok, index_live, _html} = live(conn, ~p"/meals")

      assert index_live |> element("#meals-#{meal.id} a", "Delete") |> render_click()
      refute has_element?(index_live, "#meals-#{meal.id}")
    end
  end

  describe "Show" do
    setup [:create_meal]

    test "displays meal", %{conn: conn, meal: meal} do
      {:ok, _show_live, html} = live(conn, ~p"/meals/#{meal}")

      assert html =~ "Show Meal"
      assert html =~ meal.name
    end

    test "updates meal within modal", %{conn: conn, meal: meal} do
      {:ok, show_live, _html} = live(conn, ~p"/meals/#{meal}")

      assert show_live |> element("a", "Edit") |> render_click() =~
               "Edit Meal"

      assert_patch(show_live, ~p"/meals/#{meal}/show/edit")

      assert show_live
             |> form("#meal-form", meal: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert show_live
             |> form("#meal-form", meal: @update_attrs)
             |> render_submit()

      assert_patch(show_live, ~p"/meals/#{meal}")

      html = render(show_live)
      assert html =~ "Meal updated successfully"
      assert html =~ "some updated name"
    end
  end
end
