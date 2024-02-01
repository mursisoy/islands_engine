defmodule IslandsEngine.Board do
  @moduledoc """
  Board module
  """
  alias IslandsEngine.Coordinate
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

  @doc """
  Guess a coordinate onto the board

  ## Examples
      iex> alias IslandsEngine.{Coordinate, Island, Board}
      iex> board = Board.new()
      iex> {:ok, coordinate} = Coordinate.new(5, 5)
      iex> {:ok, island} = Island.new(:dot, coordinate)
      iex> board = Board.position_island(board, :dot, island)
      iex> Board.guess(board, coordinate)
      {:hit, :dot, :win,
        %{
          dot: %IslandsEngine.Island{
            coordinates: MapSet.new([%IslandsEngine.Coordinate{row: 5, col: 5}]),
            hit_coordinates: MapSet.new([%IslandsEngine.Coordinate{row: 5, col: 5}])
          }
        }}

      iex> alias IslandsEngine.{Coordinate, Island, Board}
      iex> board = Board.new()
      iex> {:ok, coordinate} = Coordinate.new(5, 5)
      iex> {:ok, island} = Island.new(:dot, coordinate)
      iex> board = Board.position_island(board, :dot, island)
      iex> {:ok, miss_coordinate} = Coordinate.new(1, 5)
      iex> Board.guess(board, miss_coordinate)
      {:miss, :none, :no_win,
        %{
          dot: %IslandsEngine.Island{
            coordinates: MapSet.new([%IslandsEngine.Coordinate{row: 5, col: 5}]),
            hit_coordinates: MapSet.new([])
          }
        }}

      iex> alias IslandsEngine.{Coordinate, Island, Board}
      iex> board = Board.new()
      iex> {:ok, square_coordinate} = Coordinate.new(5, 5)
      iex> {:ok, square_island} = Island.new(:square, square_coordinate)
      iex> board = Board.position_island(board, :square, square_island)
      iex> {:ok, dot_coordinate} = Coordinate.new(1, 5)
      iex> {:ok, dot_island} = Island.new(:dot, dot_coordinate)
      iex> board = Board.position_island(board, :dot, dot_island)
      iex> Board.guess(board, square_coordinate)
      {:hit, :none, :no_win,
        %{
          square: %IslandsEngine.Island{
            coordinates: MapSet.new([
              %IslandsEngine.Coordinate{row: 5, col: 5},
              %IslandsEngine.Coordinate{row: 6, col: 5},
              %IslandsEngine.Coordinate{row: 5, col: 6},
              %IslandsEngine.Coordinate{row: 6, col: 6}
            ]),
            hit_coordinates: MapSet.new([
              %IslandsEngine.Coordinate{row: 5, col: 5}
            ])
          },
          dot: %IslandsEngine.Island{
            coordinates: MapSet.new([
              %IslandsEngine.Coordinate{row: 1, col: 5}]
            ),
            hit_coordinates: MapSet.new([])
          }
      }}
  """
  def guess(board, %Coordinate{} = coordinate) do
    board
    |> check_all_islands(coordinate)
    |> guess_response(board)
  end

  defp check_all_islands(board, coordinate) do
    Enum.find_value(board, :miss, fn {key, island} ->
      case Island.guess(island, coordinate) do
        {:hit, island} -> {key, island}
        :miss -> false
      end
    end)
  end

  defp guess_response({key, island}, board) do
    board = %{board | key => island}
    {:hit, forest_check(board, key), win_check(board), board}
  end
  defp guess_response(:miss, board) do
    {:miss, :none, :no_win, board}
  end

  defp forest_check(board, key) do
    case forested?(board, key) do
      true -> key
      false -> :none
    end
  end

  defp forested?(board, key) do
    board
    |> Map.fetch!(key)
    |> Island.forested?()
  end

  defp win_check(board) do
    case all_forested?(board) do
      true -> :win
      false -> :no_win
    end
  end

  defp all_forested?(board) do
    Enum.all?(board, fn {_key, island} ->
      Island.forested?(island)
    end)
  end
end
