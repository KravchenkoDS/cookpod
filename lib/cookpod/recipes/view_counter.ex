defmodule Cookpod.Recipes.ViewCounter do
  use GenServer

  @moduledoc false

  def start_link(_opts) do
    GenServer.start_link(__MODULE__, %{}, name: __MODULE__)
  end

  def inc(recipe_id), do: GenServer.cast(__MODULE__, {:increment, recipe_id})

  def stats(), do: GenServer.call(__MODULE__, :stats)

  def init(state), do: {:ok, state}

  def handle_cast({:increment, recipe_id}, state) do
    recipe_stats = Map.get(state, recipe_id, %{id: recipe_id, views: 0})
    views_count = Map.fetch!(recipe_stats, :views)
    new_state = Map.put(state, recipe_id, %{recipe_stats | views: views_count + 1})
    {:noreply, new_state}
  end

  def handle_call(:stats, _from, state), do: {:reply, Map.values(state), state}
end