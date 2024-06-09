defmodule IslandsEngine.Rules do
  alias __MODULE__

  defstruct state: :initialized,
            player1: :islands_not_set,
            player2: :islands_not_set

  @doc """
  Creates a new rule struct

  ## Examples

      iex> alias IslandsEngine.Rules
      iex> Rules.new()
      %IslandsEngine.Rules{state: :initialized}
  """
  def new(), do: %Rules{}

  @doc """
  Check state from :initialized to :players_set

  ## Examples

      iex> alias IslandsEngine.Rules
      iex> rules = Rules.new()
      %IslandsEngine.Rules{state: :initialized, player1: :islands_not_set, player2: :islands_not_set}
      iex> {:ok, rules} = Rules.check(rules, :add_player)
      {:ok, %IslandsEngine.Rules{state: :players_set}}
      iex> :error = Rules.check(rules, :completely_wrong_action)
      :error
  """
  def check(%Rules{state: :initialized} = rules, :add_player) do
    {:ok, %Rules{rules | state: :players_set}}
  end

  def check(%Rules{state: :players_set} = rules, {:position_islands, player}) do
    case Map.fetch!(rules, player) do
      :islands_set -> :error
      :islands_not_set -> {:ok, rules}
    end
  end

  def check(_state, _action), do: :error
end
