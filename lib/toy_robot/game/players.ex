defmodule ToyRobot.Game.Players do
  alias ToyRobot.Game.Player
  alias ToyRobot.Table

  def all(registry_id) do
    registry_id
    |> Registry.select([{{:"$1", :_, :_}, [], [:"$1"]}])
    |> Enum.map(fn (player_name) ->
      Player.process_name(registry_id, player_name)
    end)
  end

  def except(players, name) do
    players |> Enum.reject(&(&1 == name))
  end

  def positions(players) do
    players |> Enum.map(&(&1 |> Player.report |> coordinates))
  end

  def position_available?(occupied_positions, position) do
    (position |> coordinates()) not in occupied_positions
  end

  def next_position(registry_id, name) do
    registry_id |> find(name) |> Player.next_position
  end

  def move(registry_id, name) do
    registry_id |> find(name) |> Player.move
  end

  def report(registry_id, name) do
    registry_id |> find(name) |> Player.report
  end

  def available_positions(occupied_positions, table) do
    Table.valid_positions(table) -- occupied_positions
  end

  def change_position_if_occupied(occupied_positions, table, position) do
    if occupied_positions |> position_available?(position) do
      position
    else
      new_position =
        occupied_positions
        |> available_positions(table)
        |> Enum.random

      new_position |> Map.put(:facing, position.facing)
    end
  end

  defp find(registry_id, name) do
    registry_id |> Player.process_name(name)
  end

  defp coordinates(position) do
    position |> Map.take([:north, :east])
  end
end
