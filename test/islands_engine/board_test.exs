defmodule IslandsEngine.BoardTest do
  use ExUnit.Case
  doctest IslandsEngine.Board
  alias IslandsEngine.{Island, Coordinate, Board}

  describe "testing board island position" do
    test "positioning two islands" do
      {:ok, square_island_coordinate} = Coordinate.new(1, 1)
      {:ok, square_island} = Island.new(:square, square_island_coordinate)
      {:ok, dot_island_coordinate} = Coordinate.new(5, 5)
      {:ok, dot_island} = Island.new(:dot, dot_island_coordinate)
      board = Board.new()
              |> Board.position_island(:square, square_island)
              |> Board.position_island(:dot, dot_island)
      assert Enum.all?([:square, :dot], &(Map.has_key?(board, &1)))
    end

    test "positioning two overlapping islands" do
      {:ok, square_island_coordinate} = Coordinate.new(1, 1)
      {:ok, square_island} = Island.new(:square, square_island_coordinate)
      {:ok, dot_island_coordinate} = Coordinate.new(1, 1)
      {:ok, dot_island} = Island.new(:dot, dot_island_coordinate)
      assert {:error, :overlapping_island} = Board.new()
              |> Board.position_island(:square, square_island)
              |> Board.position_island(:dot, dot_island)
    end
  end


end
