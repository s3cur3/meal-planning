defmodule MpWeb.MealLive.Index do
  use MpWeb, :live_view

  alias Mp.Meals
  alias Mp.Meals.Meal

  @impl true
  def mount(_params, _session, socket) do
    {:ok, stream(socket, :meals, Meals.list_meals())}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, "Edit Meal")
    |> assign(:meal, Meals.get_meal!(id))
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "New Meal")
    |> assign(:meal, %Meal{})
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Listing Meals")
    |> assign(:meal, nil)
  end

  @impl true
  def handle_info({MpWeb.MealLive.FormComponent, {:saved, meal}}, socket) do
    {:noreply, stream_insert(socket, :meals, meal)}
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    meal = Meals.get_meal!(id)
    {:ok, _} = Meals.delete_meal(meal)

    {:noreply, stream_delete(socket, :meals, meal)}
  end
end
