defmodule IslandsEngine.Board do
  @moduledoc """
  Board module
  """
  alias IslandsEngine.Island

  @doc """
  Create new board

  ## Examples

      iex> alias IslandsEngine.Board
      iex> Board.new()
      %{}
  """
  def new(), do: %{}

  @doc """
  Positionates an island onto a board

  ## Examples
      iex> alias IslandsEngine.{Board, Coordinate, Island}
      iex> {:ok, coordinate} = Coordinate.new(1, 1)
      iex> {:ok, island} = Island.new(:square, coordinate)
      iex> board = Board.new()
      iex> Board.position_island(board, :square, island)
      %{
        square: %IslandsEngine.Island{
          coordinates: MapSet.new([
            %IslandsEngine.Coordinate{row: 1, col: 1},
            %IslandsEngine.Coordinate{row: 1, col: 2},
            %IslandsEngine.Coordinate{row: 2, col: 1},
            %IslandsEngine.Coordinate{row: 2, col: 2}
          ]),
          hit_coordinates: MapSet.new([])
        }
      }
  """
  def position_island(board, key, %Island{} = island) do
    case overlaps_existing_island?(board, key, island) do
      true -> {:error, :overlapping_island}
      false -> Map.put(board, key, island)
    end
  end

  defp overlaps_existing_island?(board, new_key, new_island) do
    Enum.any?(board, fn {key, island} ->
      key != new_key and Island.overlaps?(island, new_island)
    end)
  end

  @doc """
  Check wheter all islands types are positioned on board

  ## Examples

      iex> alias IslandsEngine.Board
      iex> board = Board.new()
      iex> Board.all_islands_positioned?(board)
      false
  """
  def all_islands_positioned?(board) do
    Enum.all?(Island.types, &(Map.has_key?(board, &1)))
  end


end
