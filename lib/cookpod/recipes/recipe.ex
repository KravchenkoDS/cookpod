defmodule Cookpod.Recipes.Recipe do
  use Ecto.Schema
  use Arc.Ecto.Schema
  import Ecto.Changeset

  alias Cookpod.Recipes.Picture

  schema "recipes" do
    field :description, :string
    field :name, :string
    field :picture, Picture.Type

    timestamps()
  end

  @doc false
  def changeset(recipe, attrs) do
    recipe
    |> cast(attrs, [:name, :description])
    |> cast_attachments(attrs, [:picture])
    |> validate_required([:name, :description])
    |> unique_constraint(:name)
  end

  def new() do
    %__MODULE__{
    }
  end  
end
