defmodule Day2.CubeConundrum do
  @cubes_set %{
    "red" => 12,
    "green" => 13,
    "blue" => 14
  }

  def possible_games(games) do
    Enum.reduce(games, {0, 0}, fn game, acc1 ->
      [_, gameId] = Regex.run(~r/Game (\d+):/, game)

      game
      |> String.replace(~r/Game \d+: /, "")
      |> separate_sets()
      |> Enum.reduce(
        {
          false,
          %{
            "red" => 0,
            "green" => 0,
            "blue" => 0
          }
        },
        fn game, acc -> count_cubes(game, acc) end
      )
      |> calculate_power(acc1)
      |> calculate_index(gameId)
    end)
  end

  defp calculate_power(
         {_, %{"blue" => blue, "green" => green, "red" => red}} = value,
         {index, power}
       ) do
    set_power = blue * green * red
    {value, index, power + set_power}
  end

  defp calculate_index({{false, _}, index, power}, gameId) do
    new_index = String.to_integer(gameId) + index
    {new_index, power}
  end

  defp calculate_index({{true, _}, index, power}, _) do
    {index, power}
  end

  defp separate_sets(sets), do: String.split(sets, ~r/\s*;\s*/)

  defp count_cubes(game, {validation, acc}) do
    {validation_status, %{"blue" => blue, "green" => green, "red" => red}} =
      String.split(game, ~r/\s*,\s*/)
      |> Enum.reduce(
        {nil,
         %{
           "red" => "0",
           "green" => "0",
           "blue" => "0"
         }},
        fn index, acc ->
          Regex.run(~r/(\d+)\s*(\w+)/, index) |> validate_set(acc)
        end
      )

    validation = validation_status || validation

    update_cube_counts(validation, acc, blue, green, red)
  end

  defp update_cube_counts(validation, acc, blue, green, red) do
    {validation,
     acc
     |> Map.put("blue", max_value(String.to_integer(blue), Map.get(acc, "blue", "0")))
     |> Map.put(
       "green",
       max_value(String.to_integer(green), Map.get(acc, "green", "0"))
     )
     |> Map.put("red", max_value(String.to_integer(red), Map.get(acc, "red", "0")))}
  end

  defp max_value(a, b) do
    if a > b, do: a, else: b
  end

  defp validate_set([_, number, color], {validation_status, acc}) do
    cube_counts = calculate_cube_counts(number, color, acc)
    validation = @cubes_set[color] < String.to_integer(number)

    validation_status = validation_status || validation

    {validation_status, cube_counts}
  end

  defp calculate_cube_counts(number, color, acc) do
    if Map.get(acc, color) < number, do: Map.put(acc, color, number), else: acc
  end
end
