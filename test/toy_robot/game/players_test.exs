defmodule ToyRobot.Game.PlayersTest do
  use ExUnit.Case, async: true

  alias ToyRobot.Table
  alias ToyRobot.Game.Players

  describe "available positions" do
    setup do
      table = %Table{
        north_boundary: 1,
        east_boundary: 1,
      }

      {:ok, table: table}
    end

    test "does not include the occupied positions", %{table: table} do
      occupied_positions = [%{north: 0, east: 0}]

      available_positions = Players.available_positions(
        occupied_positions,
        table
      )

      assert occupied_positions not in available_positions
    end
  end

  describe "change_position_if_occupied" do
    setup do
      table = %Table{
        north_boundary: 1,
        east_boundary: 1,
      }

      {:ok, table: table}
    end

    test "changes position if it is occupied", %{table: table} do
      occupied_positions = [%{north: 0, east: 0}]
      original_position = %{north: 0, east: 0, facing: :north}

      new_position = Players.change_position_if_occupied(
        occupied_positions,
        table,
        original_position
      )

      assert new_position != original_position
      assert new_position.facing == original_position.facing
    end

    test "does not change position if it is not occupied", %{table: table} do
      occupied_positions = []
      original_position = %{north: 0, east: 0, facing: :north}

      assert Players.change_position_if_occupied(
        occupied_positions,
        table,
        original_position
      ) == original_position
    end
  end
end
