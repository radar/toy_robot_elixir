defmodule ToyRobot.Game.Table do
  use GenServer

  alias ToyRobot.Table
  alias ToyRobot.Game.{Player, PlayerSupervisor}

  def start_link(args) do
    GenServer.start_link(__MODULE__, args, name: __MODULE__)
  end

  def init(name: name, north_boundary: north_boundary, east_boundary: east_boundary) do
    table = %Table{
      north_boundary: north_boundary,
      east_boundary: east_boundary
    }

    {:ok, %{name: name, table: table, players: %{}}}
  end

  def position_taken?(table, position) do
    GenServer.call(table, {:position_taken?, position})
  end

  def update(table, name, pid) do
    GenServer.call(table, {:update, name, pid})
  end

  def name(table) do
    GenServer.call(table, :name)
  end

  def table(table) do
    GenServer.call(table, :table)
  end

  def random_position(table) do
    GenServer.call(table, :random_position)
  end

  def handle_call({:position_taken?, position}, _from, %{players: players} = state) do
    taken = (position |> Map.take([:north, :east])) in (players |> positions)
    {:reply, taken, state}
  end

  def handle_call({:update, name, pid}, _from, %{players: players} = state) do
    players = players |> Map.put(name, pid) |> IO.inspect
    {:reply, :ok, %{state | players: players}}
  end

  def handle_call(:table, _from, %{table: table} = state) do
    {:reply, table, state}
  end

  def handle_call(:name, _from, %{name: name} = state) do
    {:reply, name, state}
  end

  def handle_call(
        :random_position,
        _from,
        %{
          table: %Table{north_boundary: north_boundary, east_boundary: east_boundary},
        } = state
      ) do
    pick_a_number = fn max -> 0..max |> Enum.random() end

    {:reply, %{north: pick_a_number.(north_boundary), east: pick_a_number.(east_boundary)}, state}
  end

  defp coordinates(player), do: player |> Player.report |> Map.take([:north, :east])

  defp positions(players) do
    players
    |> Map.values()
    |> Enum.filter(&Process.alive?/1)
    |> Enum.map(&coordinates/1)
  end
end
