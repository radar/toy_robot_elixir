defmodule ToyRobot.Game.Table do
  use GenServer

  alias ToyRobot.Table
  alias ToyRobot.Game.PlayerSupervisor

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
    GenServer.call(table, {:position_taken?, position |> coordinates})
  end

  def update_position(table, name, position) do
    GenServer.call(table, {:update_position, name, position})
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
    taken = position in (players |> positions)
    {:reply, taken, state}
  end

  def handle_call({:update_position, name, position}, _from, %{players: players} = state) do
    players = players |> Map.put(name, position)
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
          players: players
        } = state
      ) do
    pick_a_number = fn max -> 0..max |> Enum.random() end

    {:reply, %{north: pick_a_number.(north_boundary), east: pick_a_number.(east_boundary)}, state}
  end

  defp coordinates(position), do: position |> Map.take([:north, :east])
  defp positions(players), do: players |> Map.values() |> Enum.map(&coordinates/1)
end
