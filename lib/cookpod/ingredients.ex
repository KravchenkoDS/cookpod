defmodule Cookpod.Recipes.Ingredients do
  @moduledoc """
  The Ingredients context.
  """
  alias Cookpod.Recipes.Ingredient
  alias Cookpod.Repo


  def list_ingredients do
    Repo.all(Ingredient)
  end

  def get_ingredient!(id), do: Repo.get!(Ingredient, id)

  def create_ingredient(attrs \\ %{}) do
    %Ingredient{}
    |> Ingredient.changeset(attrs)
    |> Repo.insert()
  end

  def update_ingredient(%Ingredient{} = ingredient, attrs) do
    ingredient
    |> Ingredient.changeset(attrs)
    |> Repo.update()
  end

  def delete_ingredient(%Ingredient{} = ingredient) do
    Repo.delete(ingredient)
  end

  def change_ingredient(%Ingredient{} = ingredient) do
    Ingredient.changeset(ingredient, %{})
  end
end
