defmodule MpWeb.MealLive.Show do
  use MpWeb, :live_view

  alias Mp.Meals

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  @impl true
  def handle_params(%{"id" => id}, _, socket) do
    {:noreply,
     socket
     |> assign(:page_title, page_title(socket.assigns.live_action))
     |> assign(:meal, Meals.get_meal!(id))}
  end

  defp page_title(:show), do: "Show Meal"
  defp page_title(:edit), do: "Edit Meal"
end
