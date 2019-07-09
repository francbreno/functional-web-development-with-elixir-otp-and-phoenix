defmodule IslandsEngine.Guesses do
  alias IslandsEngine.{Guesses, Coordinate}

  @enforce_keys [:hits, :misses]
  defstruct [:hits, :misses]

  # Using MapSet to keep only unique values
  def new() do
    %Guesses{hits: MapSet.new(), misses: MapSet.new()}
  end

  # we need a function to add coordinates
  # So, it was a hit or a miss?
  # The check isn't here because the guesses are just the results
  def add(%Guesses{} = guesses, :hit, %Coordinate{} = coordinate) do
    update_in(guesses.hits, &MapSet.put(&1, coordinate))
  end

  def add(%Guesses{} = guesses, :miss, %Coordinate{} = coordinate) do
    update_in(guesses.misses, &MapSet.put(&1, coordinate))
  end
end
