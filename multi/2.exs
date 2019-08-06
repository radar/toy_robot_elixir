alias ToyRobot.Game

{:ok, table} = ToyRobot.Game.new_table(%{
  name: "Playground",
  north_boundary: 4,
  east_boundary: 4,
})

# Task #2: Cannot move onto an occupied square
izzy_origin = %{north: 0, east: 0, facing: :north}
:ok = Game.place(table, "Izzy", izzy_origin)
davros_origin = %{north: 1, east: 0, facing: :south}
:ok = Game.place(table, "Davros", davros_origin)
# Izzy occupies the square
{:error, :occupied} = Game.move(table, "Davros")
# Izzy moves off that square
%{north: 0, east: 0, facing: :east} = Game.turn_right(table, "Izzy")
%{north: 0, east: 1, facing: :east} = Game.move(table, "Izzy")

# Davros can move onto it
%{north: 0, east: 0, facing: :south} = Game.move(table, "Davros")
