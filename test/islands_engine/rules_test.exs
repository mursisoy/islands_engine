defmodule IslandsEngine.RulesTest do
  use ExUnit.Case
  alias IslandsEngine.Rules
  doctest IslandsEngine.Rules

  describe "check players can position islands" do
    setup do
      rules = Rules.new()
      rules = %Rules{rules | state: :players_set}
      {:ok, %{rules: rules}}
    end

    test "player1 can position island", %{rules: rules} do
      assert Rules.check(rules, {:position_islands, :player1}) == {:ok, rules}
    end
  end

  describe "check players cannot position islands" do
    setup do
      rules = Rules.new()
      rules = %Rules{rules | state: :players_set}
      rules = %Rules{rules | player1: :islands_set}
      {:ok, %{rules: rules}}
    end

    test "player1 cannot position island", %{rules: rules} do
      assert Rules.check(rules, {:position_islands, :player1}) == {:error}
    end
  end
end
