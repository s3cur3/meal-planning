defmodule MpWeb.MealLive.Show do
  use MpWeb, :live_view

  alias Mp.Meals

  @impl Phoenix.LiveView
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  @impl Phoenix.LiveView
  def handle_params(%{"slug_or_id" => slug_or_id}, _, socket) do
    with {:ok, meal} <- Meals.get_meal_by_slug_or_id!(slug_or_id),
         true <- Meals.owned_by?(meal, socket.assigns.current_user) do
      socket
      |> initialize(meal)
      |> noreply()
    else
      _ ->
        socket
        |> put_flash(
          :error,
          "The specified meal does not exist, or you’re not authorized to view it"
        )
        |> redirect(to: ~p"/")
        |> noreply()
    end
  end

  @impl Phoenix.LiveView
  def render(assigns) do
    ~H"""
    <.header>
      {@meal.name}
      <:subtitle>This is a meal record from your database.</:subtitle>
      <:actions>
        <.link patch={~p"/meals/#{@meal}/edit"} phx-click={JS.push_focus()}>
          <.button>Edit meal</.button>
        </.link>
      </:actions>
    </.header>

    <.list>
      <:item title="Name">{@meal.name}</:item>
      <:item title="Url">{@meal.url}</:item>
      <:item title="Images">{@meal.images}</:item>
      <:item title="Desired frequency days">{@meal.desired_frequency_days}</:item>
    </.list>

    <.back navigate={~p"/meals"}>Back to meals</.back>

    <.modal :if={@live_action == :edit} id="meal-modal" show on_cancel={JS.patch(~p"/meals/#{@meal}")}>
      <.live_component
        module={MpWeb.MealLive.FormComponent}
        id={@meal.id}
        title={@page_title}
        action={@live_action}
        meal={@meal}
        patch={~p"/meals/#{@meal}"}
      />
    </.modal>
    """
  end

  @impl Phoenix.LiveView
  def handle_info({MpWeb.MealLive.FormComponent, {:saved, meal}}, socket) do
    {:noreply, initialize(socket, meal)}
  end

  defp initialize(socket, meal) do
    socket
    |> assign(:page_title, page_title(socket.assigns.live_action))
    |> assign(:meal, meal)
  end

  defp page_title(:show), do: "Show Meal"
  defp page_title(:edit), do: "Edit Meal"
end
