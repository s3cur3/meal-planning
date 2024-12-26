defmodule Mp.Utils.SlugTest do
  use ExUnit.Case, async: true

  alias Mp.Utils.Slug

  test "parse_slug_or_id" do
    assert Slug.parse_slug_or_id("123") == {:ok, 123}
  end

  test "parse_slug_or_id with invalid id" do
    assert Slug.parse_slug_or_id("invalid") == {:error, :invalid_id}
  end

  test "url_slug with name and id" do
    assert Slug.url_slug(%{id: 123, name: "Spaghetti Carbonara"}) == "spaghetti-carbonara-123"
  end

  test "url_slug with special characters" do
    assert Slug.url_slug(%{id: 456, name: "Mac & Cheese!"}) == "mac-cheese-456"
  end

  test "url_slug with unicode characters" do
    assert Slug.url_slug(%{id: 789, name: "Café au Lait"}) == "cafe-au-lait-789"
  end

  test "parse_slug_or_id with slug format" do
    assert Slug.parse_slug_or_id("spaghetti-carbonara-123") == {:ok, 123}
  end

  test "parse_slug_or_id with slug containing numbers" do
    assert Slug.parse_slug_or_id("5-minute-pasta-456") == {:ok, 456}
  end

  test "parse_slug_or_id with malformed slug" do
    assert Slug.parse_slug_or_id("spaghetti-carbonara") == {:error, :invalid_id}
  end

  test "parse_slug_or_id with empty string" do
    assert Slug.parse_slug_or_id("") == {:error, :invalid_id}
  end
end
