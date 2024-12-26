defmodule MpWeb.MealLive.Index do
  use MpWeb, :live_view

  alias Mp.Meals
  alias Mp.Meals.Meal

  @impl Phoenix.LiveView
  def mount(_params, _session, socket) do
    {:ok, stream(socket, :meals, Meals.list_meals(socket.assigns.current_user))}
  end

  @impl Phoenix.LiveView
  def render(assigns) do
    ~H"""
    <.header>
      Listing Meals
      <:actions>
        <.link patch={~p"/meals/new"}>
          <.button>New Meal</.button>
        </.link>
      </:actions>
    </.header>

    <.table
      id="meals"
      rows={@streams.meals}
      row_click={fn {_id, meal} -> JS.navigate(~p"/meals/#{meal}") end}
    >
      <:col :let={{_id, meal}} label="Name">{meal.name}</:col>
      <:col :let={{_id, meal}} label="Url">{meal.url}</:col>
      <:col :let={{_id, meal}} label="Images">{meal.images}</:col>
      <:col :let={{_id, meal}} label="Desired frequency days">{meal.desired_frequency_days}</:col>
      <:action :let={{_id, meal}}>
        <div class="sr-only">
          <.link navigate={~p"/meals/#{meal}"}>Show</.link>
        </div>
        <.link patch={~p"/meals/#{meal}/edit-listing"}>Edit</.link>
      </:action>
      <:action :let={{id, meal}}>
        <.link
          phx-click={JS.push("delete", value: %{id: meal.id}) |> hide("##{id}")}
          data-confirm="Are you sure?"
        >
          Delete
        </.link>
      </:action>
    </.table>

    <.modal :if={@live_action in [:new, :edit]} id="meal-modal" show on_cancel={JS.patch(~p"/meals")}>
      <.live_component
        module={MpWeb.MealLive.FormComponent}
        id={@meal.id || :new}
        title={@page_title}
        action={@live_action}
        meal={@meal}
        current_user={@current_user}
        patch={~p"/meals"}
      />
    </.modal>
    """
  end

  @impl Phoenix.LiveView
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"slug_or_id" => slug_or_id}) do
    with {:ok, meal} <- Meals.get_meal_by_slug_or_id!(slug_or_id),
         true <- Meals.owned_by?(meal, socket.assigns.current_user) do
      socket
      |> assign(:page_title, "Edit Meal")
      |> assign(:meal, meal)
    else
      _ ->
        socket
        |> put_flash(
          :error,
          "The specified meal does not exist, or you’re not authorized to view it"
        )
        |> redirect(to: ~p"/")
    end
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

  @impl Phoenix.LiveView
  def handle_info({MpWeb.MealLive.FormComponent, {:saved, meal}}, socket) do
    {:noreply, stream_insert(socket, :meals, meal)}
  end

  @impl Phoenix.LiveView
  def handle_event("delete", %{"id" => id}, socket) do
    meal = Meals.get_meal!(id)
    {:ok, _} = Meals.delete_meal(meal)

    {:noreply, stream_delete(socket, :meals, meal)}
  end
end
