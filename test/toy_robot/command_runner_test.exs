defmodule Toyrobot.CommandRunnerTest do
  use ExUnit.Case, async: true

  alias ToyRobot.{CommandRunner, Simulation}

  import ExUnit.CaptureIO

  test "handles a valid place command" do
    %Simulation{robot: robot} = CommandRunner.run([{:place, %{east: 1, north: 2, facing: :north}}])

    assert robot.east == 1
    assert robot.north == 2
    assert robot.facing == :north
  end

  test "handles an invalid place command" do
    simulation = CommandRunner.run([{:place, %{east: 10, north: 10, facing: :north}}])
    assert simulation == nil
  end

  test "ignores commands until a valid placement" do
    %Simulation{robot: robot} = [
      :move,
      {:place, %{east: 1, north: 2, facing: :north}},
    ]
    |> CommandRunner.run()

    assert robot.east == 1
    assert robot.north == 2
    assert robot.facing == :north
  end

  test "handles a place + move command" do
    %Simulation{robot: robot} = [
      {:place, %{east: 1, north: 2, facing: :north}},
      :move
    ]
    |> CommandRunner.run()

    assert robot.east == 1
    assert robot.north == 3
    assert robot.facing == :north
  end

  test "handles a place + invalid move command" do
    %Simulation{robot: robot} = [
      {:place, %{east: 1, north: 4, facing: :north}},
      :move
    ]
    |> CommandRunner.run()

    assert robot.east == 1
    assert robot.north == 4
    assert robot.facing == :north
  end

  test "handles a place + turn_left command" do
    %Simulation{robot: robot} = [
      {:place, %{east: 1, north: 2, facing: :north}},
      :turn_left
    ]
    |> CommandRunner.run()

    assert robot.east == 1
    assert robot.north == 2
    assert robot.facing == :west
  end

  test "handles a place + turn_right command" do
    %Simulation{robot: robot} = [
      {:place, %{east: 1, north: 2, facing: :north}},
      :turn_right
    ]
    |> CommandRunner.run()

    assert robot.east == 1
    assert robot.north == 2
    assert robot.facing == :east
  end

  test "handles a place + report command" do
    commands = [
      {:place, %{east: 1, north: 2, facing: :north}},
      :report
    ]

    output = capture_io fn ->
      CommandRunner.run(commands)
    end

    assert output |> String.trim == "The robot is at (1, 2) and is facing NORTH"
  end

  test "handles a place + invalid command" do
    %Simulation{robot: robot} = [
      {:place, %{east: 1, north: 2, facing: :north}},
      {:invalid, "EXTERMINATE"}
    ]
    |> CommandRunner.run()

    assert robot.east == 1
    assert robot.north == 2
    assert robot.facing == :north
  end

  test "robot cannot move past the north boundary" do
    %Simulation{robot: robot} = [
      {:place, %{east: 0, north: 4, facing: :north}},
      :move
    ]
    |> CommandRunner.run()

    assert robot.north == 4
  end

  test "robot cannot move past the east boundary" do
    %Simulation{robot: robot} = [
      {:place, %{east: 4, north: 0, facing: :east}},
      :move
    ]
    |> CommandRunner.run()

    assert robot.east == 4
  end

  test "robot cannot move past the south boundary" do
    %Simulation{robot: robot} = [
      {:place, %{east: 0, north: 0, facing: :south}},
      :move
    ]
    |> CommandRunner.run()

    assert robot.north == 0
  end

  test "robot cannot move past the west boundary" do
    %Simulation{robot: robot} = [
      {:place, %{east: 0, north: 0, facing: :west}},
      :move
    ]
    |> CommandRunner.run()

    assert robot.east == 0
  end
end
