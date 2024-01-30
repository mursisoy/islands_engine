defmodule IslandsEngine.Coordinate do
  @moduledoc """
  Coordinate module for the islands game
  """
  alias __MODULE__
  @enforce_keys [:row, :col]
  defstruct [:row, :col]
  @board_range 1..10

  defguardp in_board(row, col) when row in(@board_range) and col in(@board_range)

  @doc """
  Creates a new coordinate

  ## Examples

      iex> alias IslandsEngine.Coordinate
      iex> Coordinate.new(1,1)
      {:ok, %Coordinate{row: 1, col: 1}}

      iex> alias IslandsEngine.Coordinate
      iex> Coordinate.new(1,1)
      {:ok, %Coordinate{row: 1, col: 1}}

      iex> alias IslandsEngine.Coordinate
      iex> Coordinate.new(0,1)
      {:error, :invalid_coordinate}

      iex> alias IslandsEngine.Coordinate
      iex> Coordinate.new(1,11)
      {:error, :invalid_coordinate}

  """
  def new(row, col) when in_board(row, col), do:
    {:ok, %Coordinate{row: row, col: col}}
  def new(_row, _col), do: {:error, :invalid_coordinate}

end
