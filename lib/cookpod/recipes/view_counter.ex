defmodule Cookpod.Recipes.ViewCounter do
  use GenServer

  @moduledoc false
  @table :recipe_views
  @end_of_table :"$end_of_table"  
  @batch_size 100

  def start_link(_opts) do
    GenServer.start_link(__MODULE__, %{}, name: __MODULE__)
  end

  def init(state) do
    :ets.new(@table, [:named_table, :set, :protected, read_concurrency: true])
    {:ok, state}
  end

  def handle_cast({:increment, id}, _state) do
    new_state = Map.update!(get_stats(id), :views, &(&1 + 1))
    :ets.insert(@table, {id, new_state})
    {:noreply, new_state}
  end

  def handle_call(:stats, _from, state), do: {:reply, Map.values(state), state}  

  def inc(id), do: GenServer.cast(__MODULE__, {:increment, id})

  def stats() do
    Stream.resource(
      fn ->
            :ets.select(@table, [{{:"$1", :"$2"}, [], [:"$2"]}], @batch_size)
      end,      
      fn acc ->
            case acc do
              @end_of_table ->
                {:halt, acc}
              {list, continuation} ->
                {list, :ets.select(continuation)}
            end
      end,      
      fn _ -> :ok end
    )
  end

  def get_stats(id) do
    case :ets.lookup(@table, id) do
      [] -> %{id: id, views: 0}
      [{_key, stats}] -> stats
    end
  end
end