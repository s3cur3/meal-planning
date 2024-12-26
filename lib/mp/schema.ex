defmodule Mp.Schema do
  defmacro __using__(_) do
    quote do
      use TypedEctoSchema
      import Ecto.Changeset
      @timestamps_opts [type: :utc_datetime_usec]
    end
  end
end
