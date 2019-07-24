defmodule ToyRobot.CommandInterpreterTest do
  use ExUnit.Case, async: true
  doctest ToyRobot.CommandInterpreter

  alias ToyRobot.CommandInterpreter

  test "handles all commands" do
    commands = ["PLACE 1,2,NORTH", "MOVE", "LEFT", "RIGHT", "REPORT"]
    commands |> CommandInterpreter.interpret()
  end

  test "marks invalid commands as invalid" do
    commands = ["SPIN", "TWIRL", "EXTERMINATE"]
    output = commands |> CommandInterpreter.interpret()
    assert output == [
      {:invalid, "SPIN"},
      {:invalid, "TWIRL"},
      {:invalid, "EXTERMINATE"}
    ]
  end
end
