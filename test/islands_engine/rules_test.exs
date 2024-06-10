defmodule IslandsEngine.RulesTest do
  use ExUnit.Case
  alias IslandsEngine.Rules
  doctest IslandsEngine.Rules

  defp setup_player1_turn(_) do
    rules = Rules.new()
    {:ok, rules} = Rules.check(rules, :add_player)
    {:ok, rules} = Rules.check(rules, {:position_islands, :player1})
    {:ok, rules} = Rules.check(rules, {:position_islands, :player2})
    {:ok, rules} = Rules.check(rules, {:set_islands, :player1})
    {:ok, rules} = Rules.check(rules, {:set_islands, :player2})
    %{rules: rules}
  end

  describe "" do
    test "rules initialization" do
      rules = Rules.new()
      assert rules.state == :initialized
    end

    test "players set transition" do
      rules = Rules.new()
      {:ok, rules} = Rules.check(rules, :add_player)
      assert rules.state == :players_set
    end

    test "players position islands and begin player 1 turn" do
      rules = Rules.new()
      {:ok, rules} = Rules.check(rules, :add_player)

      {:ok, rules} = Rules.check(rules, {:position_islands, :player1})
      assert rules.state == :players_set

      {:ok, rules} = Rules.check(rules, {:position_islands, :player2})
      assert rules.state == :players_set

      {:ok, rules} = Rules.check(rules, {:set_islands, :player1})
      assert rules.state == :players_set && rules.player1 == :islands_set
      assert Rules.check(rules, {:position_islands, :player1}) == :error

      {:ok, rules} = Rules.check(rules, {:position_islands, :player2})
      assert rules.state == :players_set

      {:ok, rules} = Rules.check(rules, {:set_islands, :player2})
      assert rules.state == :player1_turn
    end
  end

  describe "when" do
    setup [:setup_player1_turn]

    test "player1 guess its player2 turn", context do
      {:ok, rules} = Rules.check(context[:rules], {:guess_coordinate, :player1})
      assert rules.state == :player2_turn
    end

    test "player2 guess its player1 turn again", context do
      {:ok, rules} = Rules.check(context[:rules], {:guess_coordinate, :player1})
      {:ok, rules} = Rules.check(rules, {:guess_coordinate, :player2})
      assert rules.state == :player1_turn
    end

    test "in player1_turn, player2 cannot guess coordinate", context do
      assert Rules.check(context[:rules], {:guess_coordinate, :player2}) == :error
    end

    test "in player2_turn , player1 cannot guess coordinate", context do
      {:ok, rules} = Rules.check(context[:rules], {:guess_coordinate, :player1})
      assert Rules.check(rules, {:guess_coordinate, :player1}) == :error
    end

    test "in player2_turn if :no_win state remains the same", context do
      {:ok, rules} = Rules.check(context[:rules], {:guess_coordinate, :player1})
      {:ok, rules} = Rules.check(rules, {:win_check, :no_win})
      assert rules.state == :player2_turn
    end

    test "in player2_turn  if :win state goes :game_over", context do
      {:ok, rules} = Rules.check(context[:rules], {:guess_coordinate, :player1})
      {:ok, rules} = Rules.check(rules, {:win_check, :win})
      assert rules.state == :game_over
    end

    test "in player1_turn if :no_win state remains the same", context do
      {:ok, rules} = Rules.check(context[:rules], {:win_check, :no_win})
      assert rules.state == :player1_turn
    end

    test "in player1_turn  if :win state goes :game_over", context do
      {:ok, rules} = Rules.check(context[:rules], {:win_check, :win})
      assert rules.state == :game_over
    end
  end

  # describe "check all transitions" do
  #   rules = Rules.new()
  #   assert rules.state == :initialized

  #   {:ok, rules} = Rules.check(rules, :add_player)
  #   assert rules.state == :players_set

  #   {:ok, rules} = Rules.check(rules, {:position_islands, :player1})
  #   assert rules.state == :players_set

  #   {:ok, rules} = Rules.check(rules, {:position_islands, :player2})
  #   assert rules.state == :players_set

  #   {:ok, rules} = Rules.check(rules, {:set_islands, :player1})
  #   assert rules.state == :players_set && rules.player1 == :islands_set
  #   assert Rules.check(rules, {:position_islands, :player1}) == :error

  #   {:ok, rules} = Rules.check(rules, {:position_islands, :player2})
  #   assert rules.state == :players_set

  #   {:ok, rules} = Rules.check(rules, {:set_islands, :player2})
  #   assert rules.state == :player1_turn
  #   assert Rules.check(rules, {:guess_coordinate, :player2}) == :error

  #   {:ok, rules} = Rules.check(rules, {:guess_coordinate, :player1})
  #   assert rules.state == :player2_turn
  #   assert Rules.check(rules, {:guess_coordinate, :player1}) == :error

  #   {:ok, rules} = Rules.check(rules, {:guess_coordinate, :player2})
  #   assert rules.state == :player1_turn

  #   {:ok, rules} = Rules.check(rules, {:win_check, :no_win})
  #   assert rules.state == :player1_turn

  #   assert {:ok, %Rules{state: :game_over}} == Rules.check(rules, {:win_check, :win})
  # end
end
