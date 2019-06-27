defmodule ToyRobot.CommandInterpreter do
  @doc """
  Interprets commands from a commands list, in preparation for running them.

  ## Examples

      iex> alias ToyRobot.CommandInterpreter
      ToyRobot.CommandInterpreter
      iex> commands = ["PLACE 1,2,NORTH", "MOVE", "LEFT", "RIGHT", "REPORT"]
      ["PLACE 1,2,NORTH", "MOVE", "LEFT", "RIGHT", "REPORT"]
      iex> commands |> CommandInterpreter.interpret()
      [
        {:place, %{north: 2, east: 1, facing: :north}},
        :move,
        :turn_left,
        :turn_right,
        :report,
      ]
  """
  def interpret(commands) do
    commands |> Enum.map(&do_interpret/1)
  end

  defp do_interpret(("PLACE" <> _rest) = command) do
    format = ~r/\APLACE (\d+),(\d+),(NORTH|EAST|SOUTH|WEST)\z/
    case Regex.run(format, command) do
      [_command, east, north, facing] ->
        to_integer = &String.to_integer/1

        {:place, %{
          east: to_integer.(east),
          north: to_integer.(north),
          facing: facing |> String.downcase |> String.to_atom
        }}
      nil -> {:invalid, command}
    end
  end

  defp do_interpret("MOVE"), do: :move
  defp do_interpret("LEFT"), do: :turn_left
  defp do_interpret("RIGHT"), do: :turn_right
  defp do_interpret("REPORT"), do: :report
  defp do_interpret(command), do: {:invalid, command}
end
