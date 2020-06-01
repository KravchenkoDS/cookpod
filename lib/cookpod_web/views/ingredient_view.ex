defmodule CookpodWeb.IngredientView do
  use CookpodWeb, :view

  alias Cookpod.Recipes
  alias Cookpod.Recipes.Products

  def recipe_name(ingredient) do
  	recipe = Recipes.get_recipe(ingredient.recipe_id)
  	case recipe do
      nil -> ""
      _ -> recipe.name
    end
	end

  def product_name(ingredient) do
  	product = Products.get_product!(ingredient.product_id)
  	case product do
      nil -> ""
      _ -> product.name
    end
	end

	def select_recipes do
		Recipes.list_name_id
	end

	def select_products do
		Products.list_name_id
	end

end