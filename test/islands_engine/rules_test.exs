defmodule IslandsEngine.RulesTest do
  use ExUnit.Case
  alias IslandsEngine.Rules
  doctest IslandsEngine.Rules

  describe "check players can position islands" do
    setup do
      rules = Rules.new()
      {:ok, rules} = Rules.check(rules, :add_player)
      {:ok, %{rules: rules}}
    end

    test "player1 can position island", %{rules: rules} do
      assert Rules.check(rules, {:position_islands, :player1}) == {:ok, rules}
    end

    test "player1 cannot position island", %{rules: rules} do
      {:ok, rules} = Rules.check(rules, {:set_islands, :player1})
      assert Rules.check(rules, {:position_islands, :player1}) == :error
    end

    test "player1_turn transition", %{rules: rules} do
      {:ok, rules} = Rules.check(rules, {:set_islands, :player1})
      {:ok, rules} = Rules.check(rules, {:set_islands, :player2})
      assert rules.state == :player1_turn
    end
  end
end
