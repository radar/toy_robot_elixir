defmodule ToyRobot.Game.Player do
  use GenServer

  alias ToyRobot.{Robot, Simulation}
  alias ToyRobot.Game.Players

  def start(table, position) do
    GenServer.start(__MODULE__, [table: table, position: position])
  end

  def start_link(registry_id: registry_id, table: table, position: position, name: name) do
    name = process_name(registry_id, name)
    GenServer.start_link(
      __MODULE__,
      [
        registry_id: registry_id,
        table: table,
        position: position,
        name: name
      ],
      name: name
    )
  end

  def init([table: table, position: position]) do
    simulation = %Simulation{
      table: table,
      robot: struct(Robot, position)
    }

    {:ok, simulation}
  end

  def init([registry_id: registry_id, table: table, position: position, name: name]) do
    position =
      registry_id
      |> Players.all
      |> Players.except(name)
      |> Players.positions
      |> Players.change_position_if_occupied(table, position)

    simulation = %Simulation{
      table: table,
      robot: struct(Robot, position)
    }

    {:ok, simulation}
  end

  def process_name(registry_id, name) do
    {:via, Registry, {registry_id, name}}
  end

  def report(player) do
    GenServer.call(player, :report)
  end

  def move(player) do
    GenServer.cast(player, :move)
  end

  def next_position(player) do
    GenServer.call(player, :next_position)
  end

  def handle_call(:report, _from, simulation) do
    {:reply, simulation |> Simulation.report, simulation}
  end

  def handle_cast(:move, simulation) do
    {:ok, new_simulation} = simulation |> Simulation.move()
    {:noreply, new_simulation}
  end

  def handle_call(:next_position, _from, simulation) do
    next_position = simulation |> Simulation.next_position()
    {:reply, next_position, simulation}
  end
end
