alias ToyRobot.Game

# Task #3: Cannot respawn on an occupied square
{:ok, table} = ToyRobot.Game.new_table(%{
  name: "Playground",
  north_boundary: 4,
  east_boundary: 4,
})

izzy_origin = %{north: 0, east: 1, facing: :north}
:ok = Game.place(table, "Izzy", izzy_origin)

davros_origin = %{north: 1, east: 1, facing: :west}
:ok = Game.place(table, "Davros", davros_origin)
# Davros moves off starting square, moving west
%{north: 1, east: 0} = Game.move(table, "Davros")

# Izzy moves onto Davros's origin square
%{north: 1, east: 1, facing: :north} = Game.move(table, "Izzy")

# Davros moves off the edge of the table, falling to his doom.
%{north: 1, east: 0} = Game.move(table, "Davros")

# # Davros's origin is taken, so he should start in a random position
Game.report(table, "Davros") |> IO.inspect(label: "Davros")

# Ensure both robots (and the supervisor) are currently still functional
2 = DynamicSupervisor.which_children(ToyRobot.Game.PlayerSupervisor) |> Enum.count
