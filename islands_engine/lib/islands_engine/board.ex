defmodule IslandsEngine.Board do
  alias IslandsEngine.{Coordinate, Island}

  def new(), do: %{}

  # When positioning an island, it cannot overlaps
  # another one.
  def position_island(board, key, %Island{} = island) do
    case overlaps_existing_island?(board, key, island) do
      true -> {:error, :overlapping_island}
      false -> Map.put(board, key, island)
    end
  end

  # Each island needs to have set one island of each type
  def all_islands_positioned?(board) do
    Enum.all?(Island.types(), &Map.has_key?(board, &1))
  end

  # The guess flux
  def guess(board, %Coordinate{} = coordinate) do
    board
    |> check_all_islands(coordinate)
    |> guess_response(board)
  end

  # Checks each island to see if it overlapds with a new island
  # to be put in a board
  defp overlaps_existing_island?(board, new_key, new_island) do
    Enum.any?(board, fn {key, island} ->
      key != new_key and Island.overlaps?(island, new_island)
    end)
  end

  # Check if a guessed coordinate hits any island on a board
  defp check_all_islands(board, coordinate) do
    Enum.find_value(board, :miss, fn {key, island} ->
      case Island.guess(island, coordinate) do
        {:hit, island} -> {key, island}
        :miss -> false
      end
    end)
  end

  # for when it's a hit
  defp guess_response({key, island}, board) do
    board = %{board | key => island}
    {:hit, forest_check(board, key), win_check(board), board}
  end

  # for when it's a missed guess
  defp guess_response(:miss, board) do
    {:miss, :none, :no_win, board}
  end

  # return the island key if it is forested in a board
  defp forest_check(board, key) do
    case forested?(board, key) do
      true -> key
      false -> :none
    end
  end

  # Checks if a certain island is forested in a board
  # It the island is not in the board, throws an exception
  defp forested?(board, key) do
    board
    |> Map.fetch!(key)
    |> Island.forested?()
  end

  # Checks if the board is in a :win situation
  defp win_check(board) do
    case all_forested?(board) do
      true -> :win
      false -> :no_win
    end
  end

  # Are all islands in a board forested?
  defp all_forested?(board) do
    Enum.all?(board, fn {_key, island} -> Island.forested?(island) end)
  end
end
