defmodule Cookpod.Recipes.Importer do
  @moduledoc false

  use Broadway

  alias Cookpod.Repo
  alias Cookpod.Recipes.Recipe
  alias Broadway.Message

  def start_link(_opts \\ []) do
    Broadway.start_link(__MODULE__,
      name: __MODULE__,
      producer: [
        module:
          {BroadwayKafka.Producer,
           [
             hosts: [localhost: 9092],
             group_id: "group_1",
             topics: ["recipes"]
           ]},
        concurrency: 5
      ],
      processors: [
        default: [
          concurrency: 5
        ]
      ],
      batchers: [
        default: [
          batch_size: 20,
          batch_timeout: 2_000,
          concurrency: 5
        ]
      ]
    )
  end

  @impl true
  def handle_message(_, message, _) do
    message
    |> Message.update_data(fn data ->
      data
      |> Jason.decode!()
      |> recipe_changeset()
    end)
  end

  @impl true
  def handle_batch(_, messages, _, _) do
    messages
    |> Enum.each(fn e ->
      changeset = e.data

      if changeset.valid? do
        changeset |> Repo.insert()
      end
    end)

    messages
  end

  defp recipe_changeset(recipe_json) do
    Recipe.new()
    |> Recipe.changeset(%{
      name: Map.get(recipe_json, "name"),
      description: Map.get(recipe_json, "recipeInstructions") |> Enum.join(" ")
    })
  end
end