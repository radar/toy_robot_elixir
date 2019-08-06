alias ToyRobot.Game

# Task #1: Cannot start on an already occupied square
{:ok, table} = ToyRobot.Game.new_table(%{
  name: "Playground",
  north_boundary: 4,
  east_boundary: 4,
})

izzy_origin = %{north: 0, east: 0, facing: :north}
:ok = Game.place(table, "Izzy", izzy_origin)
davros_origin = %{north: 0, east: 0, facing: :south}
{:error, :occupied} = Game.place(table, "Davros", davros_origin)
