defmodule Mp.Utils.Result do
  def map_ok({:ok, value}, fun) do
    case fun.(value) do
      {:ok, _} = result -> result
      {:error, _} = result -> result
      val -> {:ok, val}
    end
  end

  def map_ok({:error, _} = result, _fun), do: result

  def unwrap!({:ok, value}), do: value
  def unwrap!({:error, reason}), do: raise("Unexpected error: #{inspect(reason)}")
end
