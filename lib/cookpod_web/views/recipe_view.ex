defmodule CookpodWeb.RecipeView do
  use CookpodWeb, :view

  alias Cookpod.Recipes

  def get_recipe_name(id) do
    recipe = Recipes.get_recipe(id)

    case recipe do
      nil -> ""
      _ -> recipe.name
    end
  end  
end