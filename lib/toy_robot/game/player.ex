defmodule ToyRobot.Game.Player do
  use GenServer

  alias ToyRobot.{Robot, Simulation}
  alias ToyRobot.Game.Table

  def start(robot) do
    GenServer.start(__MODULE__, robot)
  end

  def start_link(table: table, position: position, name: name) do
    GenServer.start_link(__MODULE__, [name: name, table: table, position: position], name: process_name(name))
  end

  def init(name: name, table: table, position: position) do
    if Table.position_taken?(table, position) do
      init(
        name: name,
        table: table,
        position: position |> Map.merge(Table.random_position(table))
      )
    else
      simulation = %Simulation{
        table: ToyRobot.Game.Table.table(table),
        robot: struct(Robot, position)
      }
      Table.update_position(table, name, position)

      {:ok, simulation}
    end
  end

  def process_name(name) do
    {:via, Registry, {ToyRobot.Game.PlayerRegistry, name}}
  end

  def report(player) do
    GenServer.call(player, :report)
  end

  def move(player) do
    GenServer.call(player, :move)
  end

  def turn_right(player) do
    GenServer.call(player, :turn_right)
  end

  def next_move(player) do
    GenServer.call(player, :next_move)
  end

  def handle_call(:report, _from, simulation) do
    {:reply, simulation |> Simulation.report(), simulation}
  end

  def handle_call(:move, _from, simulation) do
    {:ok, new_simulation} = simulation |> Simulation.move()
    {:reply, new_simulation, new_simulation}
  end

  def handle_call(:turn_right, _from, simulation) do
    {:ok, new_simulation} = simulation |> Simulation.turn_right()
    {:reply, new_simulation, new_simulation}
  end

  def handle_call(:next_move, _from, simulation) do
    next_move = simulation |> Simulation.next_move()
    {:reply, next_move, simulation}
  end
end
