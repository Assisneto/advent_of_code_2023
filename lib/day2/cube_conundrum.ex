defmodule Day2.CubeConundrum do
  @cubes_set %{
    "red" => 12,
    "green" => 13,
    "blue" => 14
  }

  def possible_games(games) do
    Enum.reduce(games, 0, fn game, acc ->
      [_, gameId] = Regex.run(~r/Game (\d+):/, game)

      game
      |> String.replace(~r/Game \d+: /, "")
      |> separate_sets()
      |> Enum.any?(fn game -> count_game(game) end)
      |> sum_index(gameId, acc)
    end)
  end

  defp sum_index(false, gameId, acc) do
    String.to_integer(gameId) + acc
  end

  defp sum_index(true, _, acc), do: acc

  defp separate_sets(sets), do: String.split(sets, ~r/\s*;\s*/)

  defp count_game(game) do
    String.split(game, ~r/\s*,\s*/)
    |> Enum.any?(fn index ->
      Regex.run(~r/(\d+)\s*(\w+)/, index) |> validate_set()
    end)
  end

  defp validate_set([_, number, color]) do
    @cubes_set[color] < String.to_integer(number)
  end
end
