defmodule Cookpod.Recipes do
  @moduledoc """
  The Recipes context.
  """
  alias Cookpod.Recipes.Ingredient
  alias Cookpod.Recipes.Recipe
  alias Cookpod.Repo

  import Ecto.Query, warn: false
  alias Cookpod.Repo

  alias Cookpod.Recipes.Recipe

  def list_recipes do
    Repo.all(Recipe)
  end

  def list_name_id do
    Repo.all(from(r in Recipe, select: {r.name, r.id}))
  end  

  def list_all, do: Recipe |> Repo.all()

  def list_recipes do
    Recipe
    |> where(state: "published")
    |> Repo.all()
  end

  def get_recipe!(id), do: Repo.get!(Recipe, id)

  def get_recipe(id), do: Repo.get(Recipe, id)  

  def create_recipe(attrs \\ %{}) do
    %Recipe{}
    |> Recipe.changeset(attrs)
    |> Repo.insert()
  end

  def update_recipe(%Recipe{} = recipe, attrs) do
    recipe
    |> Recipe.changeset(attrs)
    |> Repo.update()
  end

  def delete_recipe(%Recipe{} = recipe) do
    Repo.delete(recipe)
  end

  def change_recipe(%Recipe{} = recipe) do
    Recipe.changeset(recipe, %{})
  end

  def total_calories(recipe) do
    query =
      from ingredient in Ingredient,
        join: product in assoc(ingredient, :product),
        where: ingredient.recipe_id == ^recipe.id,
        select: fragment("SUM (amount * (fats * 9 + proteins * 4 + carbs * 4)) / 100")

    Repo.one(query)
  end

end
