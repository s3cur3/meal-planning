defmodule Mp.Utils.Slug do
  @spec url_slug(%{id: integer(), name: String.t()}) :: String.t()
  def url_slug(%{id: id, name: name}) do
    "#{Slug.slugify(name, lowercase: true)}-#{id}"
  end

  @spec id_from_url_slug(String.t()) :: {:ok, integer()} | {:error, :invalid_id}
  def id_from_url_slug(slug) do
    try do
      [id | _] =
        slug
        |> String.split("-")
        |> Enum.reverse()

      {:ok, String.to_integer(id)}
    rescue
      _ -> {:error, :invalid_id}
    end
  end

  @spec parse_slug_or_id(String.t() | integer()) :: {:ok, integer()} | {:error, :invalid_id}
  def parse_slug_or_id(slug_or_id) when is_binary(slug_or_id) do
    case id_from_url_slug(slug_or_id) do
      {:ok, id} ->
        {:ok, id}

      {:error, :invalid_id} ->
        try do
          {:ok, String.to_integer(slug_or_id)}
        rescue
          _ -> {:error, :invalid_id}
        end
    end
  end

  def parse_slug_or_id(id) when is_integer(id), do: id
end
