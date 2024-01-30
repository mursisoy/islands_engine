defmodule IslandsEngine.Coordinate do
  alias __MODULE__
  @enforce_keys [:row, :col]
  defstruct [:row, :col]
  @board_range 1..10

  defguardp in_board(row,col) when row in(@board_range) and col in(@board_range)

  def new(row, col) when in_board(row,col), do:
    {:ok, %Coordinate{row: row, col: col}}
  def new(_row,_col), do: {:error, :invalid_coordinate}

end
