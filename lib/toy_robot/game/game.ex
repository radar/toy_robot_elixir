defmodule ToyRobot.Game do
  alias ToyRobot.Game.Server

  def start([north_boundary: north_boundary, east_boundary: east_boundary]) do
    Server.start_link([
      north_boundary: north_boundary,
      east_boundary: east_boundary
    ])
  end

  def place(game, position, name) do
    with :ok <- game |> valid_position(position),
        :ok <- game |> position_available(position) do
        GenServer.call(game, {:place, position, name})
    else
      error -> error
    end
  end

  def move(game, name) do
    next_position = game |> next_position(name)

    game
    |> position_available(next_position)
    |> case do
      :ok -> GenServer.call(game, {:move, name})
      error -> error
    end
  end

  def report(game, name) do
    GenServer.call(game, {:report, name})
  end

  def player_count(game) do
    GenServer.call(game, :player_count)
  end

  defp valid_position(game, position) do
    GenServer.call(game, {:valid_position, position})
  end

  defp position_available(game, position) do
    GenServer.call(game, {:position_available, position})
  end

  defp next_position(game, name) do
    GenServer.call(game, {:next_position, name})
  end
end
