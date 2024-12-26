defmodule Mp.Utils.Number do
  def next_unique do
    System.unique_integer([:positive, :monotonic])
  end
end
