defmodule ToyRobot.Game do
  alias ToyRobot.Game.{Player, PlayerSupervisor, Table}

  def new_table(%{name: name, north_boundary: north_boundary, east_boundary: east_boundary}) do
    ToyRobot.Game.Table.start_link(
      name: name,
      north_boundary: north_boundary,
      east_boundary: east_boundary
    )
  end

  def place(table, name, position) do
    if Table.position_taken?(table, position) do
      {:error, :occupied}
    else
      {:ok, _robot} = PlayerSupervisor.start_child(table, position, table |> player_name(name))

      :ok
    end
  end

  def move(table, name) do
    next_move = table |> process_name(name) |> Player.next_move()

    if Table.position_taken?(table, next_move) do
      {:error, :occupied}
    else
      %{robot: robot} = table |> process_name(name) |> Player.move()
      player_name = table |> player_name(name)
      Table.update_position(table, player_name, robot)
      robot
    end
  end

  def turn_right(table, name) do
    %{robot: robot} = table |> process_name(name) |> Player.turn_right()
    robot
  end

  def report(table, name) do
    table |> process_name(name) |> Player.report()
  end

  defp player_name(table, name) do
    Table.name(table) <> "_" <> name
  end

  def process_name(table, name) do
    table |> player_name(name) |> Player.process_name()
  end
end
