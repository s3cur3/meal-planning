defmodule Mp.Utils.Map do
  def string_keys(map) when is_map(map) do
    transform_keys(map, &to_string/1)
  end

  def transform_keys(map, fun) when is_map(map) do
    Map.new(map, fn {k, v} -> {fun.(k), v} end)
  end
end
