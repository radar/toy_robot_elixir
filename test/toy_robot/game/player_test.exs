defmodule ToyRobot.Game.PlayerTest do
  use ExUnit.Case, async: true

  alias ToyRobot.Game.Player
  alias ToyRobot.{Robot, Table}

  def build_table do
    %Table{
      north_boundary: 4,
      east_boundary: 4
    }
  end

  describe "init" do
    setup do
      registry_id = :player_init_test
      Registry.start_link(keys: :unique, name: registry_id)

      {:ok, registry_id: registry_id}
    end

    test "maintains the original position", %{registry_id: registry_id} do
      position = %{north: 0, east: 0, facing: :north}

      {:ok, %{robot: robot}} =
        Player.init([
          registry_id: registry_id,
          table: build_table(),
          position: position,
          name: Player.process_name(registry_id, "Joanne")
        ])

      assert robot.north == 0
      assert robot.east == 0
      assert robot.facing == :north
    end
  end

  describe "init, with another player registered" do
    setup do
      registry_id = :player_init_test
      Registry.start_link(keys: :unique, name: registry_id)

      table = build_table()

      Player.start_link(
        registry_id: registry_id,
        table: table,
        position: %{north: 0, east: 0, facing: :west},
        name: "Joanna"
      )

      {:ok, registry_id: registry_id, table: table}
    end

    test "picks a random position on the board", %{registry_id: registry_id, table: table} do
      position = %{north: 0, east: 0, facing: :north}

      {:ok, %{robot: robot}} =
        Player.init([
          registry_id: registry_id,
          table: table,
          position: position,
          name: Player.process_name(registry_id, "Bobbie")
        ])

      refute match?(%{north: 0, east: 0}, robot)
      assert robot.facing == :north
    end
  end


  describe "report" do
    setup do
      starting_position = %{north: 0, east: 0, facing: :north}
      {:ok, player} = Player.start(build_table(), starting_position)
      %{player: player}
    end

    test "shows the current position of the robot", %{player: player} do
      assert Player.report(player) == %Robot{
        north: 0,
        east: 0,
        facing: :north
      }
    end
  end

  describe "move" do
    setup do
      starting_position = %{north: 0, east: 0, facing: :north}
      {:ok, player} = Player.start(build_table(), starting_position)
      %{player: player}
    end

    test "moves the robot forward one space", %{player: player} do
      :ok = Player.move(player)
      robot = Player.report(player)

      assert robot == %Robot{
        north: 1,
        east: 0,
        facing: :north
      }
    end
  end
end
