defmodule IslandsEngine.Guesses do
  @moduledoc """
  Module to store the current status of the board
  """
  alias IslandsEngine.{Coordinate, Guesses}

  @enforce_keys [:hits, :misses]
  defstruct [:hits, :misses]


  @doc """
  Creates a new guesses struct

  ## Examples

      iex> alias IslandsEngine.Guesses
      iex> Guesses.new()
      %Guesses{hits: MapSet.new([]), misses: MapSet.new([])}

  """
  def new(), do: %Guesses{hits: MapSet.new(), misses: MapSet.new()}

  @doc """
  Add a coordinate to a Guesses struct

  ## Examples

      iex> alias IslandsEngine.{Guesses,Coordinate}
      iex> guesses = Guesses.new()
      iex> {:ok, coordinate1} = Coordinate.new(1,1)
      iex> Guesses.add(guesses, :hits, coordinate1)
      %IslandsEngine.Guesses{
        hits: MapSet.new([%IslandsEngine.Coordinate{row: 1, col: 1}]),
        misses: MapSet.new([])
      }

      iex> alias IslandsEngine.{Guesses,Coordinate}
      iex> guesses = Guesses.new()
      iex> {:ok, coordinate1} = Coordinate.new(1,1)
      iex> Guesses.add(guesses, :misses, coordinate1)
      %IslandsEngine.Guesses{
        hits: MapSet.new([]),
        misses: MapSet.new([%IslandsEngine.Coordinate{row: 1, col: 1}])
      }

  """
  def add(%Guesses{} = guesses, :hits, %Coordinate{} = coordinate), do:
    update_in(guesses.hits, &MapSet.put(&1, coordinate))
  def add(%Guesses{} = guesses, :misses, %Coordinate{} = coordinate), do:
    update_in(guesses.misses, &MapSet.put(&1, coordinate))
end
