defmodule IslandsEngine.IslandTest do
  use ExUnit.Case
  doctest IslandsEngine.Island
  alias IslandsEngine.{Island, Coordinate}

  describe "create island types" do
    setup do
      {:ok, coordinate} = Coordinate.new(1, 1)
      {:ok, %{coordinate: coordinate}}
    end

    test "create square island", %{coordinate: coordinate} do
      {:ok, island} = Island.new(:square, coordinate)
      assert island == %IslandsEngine.Island{
        coordinates: MapSet.new([
          %IslandsEngine.Coordinate{row: 1, col: 1},
          %IslandsEngine.Coordinate{row: 1, col: 2},
          %IslandsEngine.Coordinate{row: 2, col: 1},
          %IslandsEngine.Coordinate{row: 2, col: 2}
        ]),
        hit_coordinates: MapSet.new([])
      }
    end

    test "create atoll island", %{coordinate: coordinate} do
      {:ok, island} = Island.new(:atoll, coordinate)
      assert island == %IslandsEngine.Island{
        coordinates: MapSet.new([
          %IslandsEngine.Coordinate{row: 1, col: 1},
          %IslandsEngine.Coordinate{row: 1, col: 2},
          %IslandsEngine.Coordinate{row: 2, col: 2},
          %IslandsEngine.Coordinate{row: 3, col: 1},
          %IslandsEngine.Coordinate{row: 3, col: 2}
        ]),
        hit_coordinates: MapSet.new([])
      }
    end

    test "create dot island", %{coordinate: coordinate} do
      {:ok, island} = Island.new(:dot, coordinate)
      assert island == %IslandsEngine.Island{
        coordinates: MapSet.new([
          %IslandsEngine.Coordinate{row: 1, col: 1}
        ]),
        hit_coordinates: MapSet.new([])
      }
    end

    test "create l_shape island", %{coordinate: coordinate} do
      {:ok, island} = Island.new(:l_shape, coordinate)
      assert island == %IslandsEngine.Island{
        coordinates: MapSet.new([
          %IslandsEngine.Coordinate{row: 1, col: 1},
          %IslandsEngine.Coordinate{row: 2, col: 1},
          %IslandsEngine.Coordinate{row: 3, col: 1},
          %IslandsEngine.Coordinate{row: 3, col: 2}
        ]),
        hit_coordinates: MapSet.new([])
      }
    end

    test "create s_shape island", %{coordinate: coordinate} do
      {:ok, island} = Island.new(:s_shape, coordinate)
      assert island == %IslandsEngine.Island{
        coordinates: MapSet.new([
          %IslandsEngine.Coordinate{row: 1, col: 2},
          %IslandsEngine.Coordinate{row: 1, col: 3},
          %IslandsEngine.Coordinate{row: 2, col: 1},
          %IslandsEngine.Coordinate{row: 2, col: 2}
        ]),
        hit_coordinates: MapSet.new([])
      }
    end

  end

  describe "create invalid island types" do
    setup do
      {:ok, coordinate} = Coordinate.new(1, 1)
      {:ok, %{coordinate: coordinate}}
    end

    test "create s_shape island", %{coordinate: coordinate} do
      assert Island.new(:non_island, coordinate) == {:error, :invalid_island_type}
    end
  end

  describe "create island out of bounds" do
    setup do
      {:ok, coordinate} = Coordinate.new(1, 10)
      {:ok, %{coordinate: coordinate}}
    end

    test "error is raised", %{coordinate: coordinate} do
      assert Island.new(:square, coordinate) == {:error, :invalid_coordinate}
    end
  end

  describe "test islands overlapping" do
    test "they overlap" do
      {:ok, square_coordinate} = Coordinate.new(1, 1)
      {:ok, square} = Island.new(:square, square_coordinate)
      {:ok, dot_coordinate} = Coordinate.new(1, 2)
      {:ok, dot} = Island.new(:dot, dot_coordinate)
      assert Island.overlaps?(square, dot) == true
    end

    test "they do not overlap" do
      {:ok, square_coordinate} = Coordinate.new(1, 1)
      {:ok, square} = Island.new(:square, square_coordinate)
      {:ok, l_shape_coordinate} = Coordinate.new(5, 5)
      {:ok, l_shape} = Island.new(:l_shape, l_shape_coordinate)
      assert Island.overlaps?(square, l_shape) == false
    end
  end
end
