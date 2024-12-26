defmodule MpWeb.MealLive.FormComponent do
  use MpWeb, :live_component

  alias Mp.Meals

  @impl true
  def render(assigns) do
    ~H"""
    <div>
      <.header>
        {@title}
        <:subtitle>Use this form to manage meal records in your database.</:subtitle>
      </.header>

      <.simple_form
        for={@form}
        id="meal-form"
        phx-target={@myself}
        phx-change="validate"
        phx-submit="save"
      >
        <.input field={@form[:name]} type="text" label="Name" />
        <.input field={@form[:url]} type="text" label="Url" />
        <.input
          field={@form[:images]}
          type="select"
          multiple
          label="Images"
          options={[{"Option 1", "option1"}, {"Option 2", "option2"}]}
        />
        <.input field={@form[:desired_frequency_days]} type="number" label="Desired frequency days" />
        <:actions>
          <.button phx-disable-with="Saving...">Save Meal</.button>
        </:actions>
      </.simple_form>
    </div>
    """
  end

  @impl true
  def update(%{meal: meal} = assigns, socket) do
    {:ok,
     socket
     |> assign(assigns)
     |> assign_new(:form, fn ->
       to_form(Meals.change_meal(meal))
     end)}
  end

  @impl true
  def handle_event("validate", %{"meal" => meal_params}, socket) do
    changeset = Meals.change_meal(socket.assigns.meal, meal_params)
    {:noreply, assign(socket, form: to_form(changeset, action: :validate))}
  end

  def handle_event("save", %{"meal" => meal_params}, socket) do
    save_meal(socket, socket.assigns.action, meal_params)
  end

  defp save_meal(socket, :edit, meal_params) do
    case Meals.update_meal(socket.assigns.meal, meal_params) do
      {:ok, meal} ->
        notify_parent({:saved, meal})

        {:noreply,
         socket
         |> put_flash(:info, "Meal updated successfully")
         |> push_patch(to: socket.assigns.patch)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, form: to_form(changeset))}
    end
  end

  defp save_meal(socket, :new, meal_params) do
    case Meals.create_meal(meal_params) do
      {:ok, meal} ->
        notify_parent({:saved, meal})

        {:noreply,
         socket
         |> put_flash(:info, "Meal created successfully")
         |> push_patch(to: socket.assigns.patch)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, form: to_form(changeset))}
    end
  end

  defp notify_parent(msg), do: send(self(), {__MODULE__, msg})
end
