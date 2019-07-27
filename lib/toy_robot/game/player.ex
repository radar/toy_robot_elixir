defmodule ToyRobot.Game.Player do
  use GenServer

  alias ToyRobot.{Robot, Simulation, Table}

  def start(position) do
    GenServer.start(__MODULE__, position)
  end

  def start_link([position: position, name: name]) do
    GenServer.start_link(__MODULE__, position, name: process_name(name))
  end

  def init(position) do
    simulation = %Simulation{
      table: %Table{
        north_boundary: 4,
        east_boundary: 4,
      },
      robot: struct(Robot, position)
    }

    {:ok, simulation}
  end

  def process_name(name) do
    {:via, Registry, {ToyRobot.Game.PlayerRegistry, name}}
  end

  def report(player) do
    GenServer.call(player, :report)
  end

  def move(player) do
    GenServer.cast(player, :move)
  end

  def handle_call(:report, _from, simulation) do
    {:reply, simulation |> Simulation.report, simulation}
  end

  def handle_cast(:move, simulation) do
    {:ok, new_simulation} = simulation |> Simulation.move()
    {:noreply, new_simulation}
  end
end
