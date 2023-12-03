defmodule Day1.Trebuchet do
  @word_to_number_map %{
    "one" => "1",
    "two" => "2",
    "three" => "3",
    "four" => "4",
    "five" => "5",
    "six" => "6",
    "seven" => "7",
    "eight" => "8",
    "nine" => "9"
  }

  def calculate_total(input) do
    calculate_total_recursive(input, 0)
  end

  defp calculate_total_recursive([head | tail], total) do
    graphemes = String.graphemes(head)

    {numbers, _} = Enum.reduce(graphemes, {[], ""}, &extract_numbers/2)

    new_total = calculate_sum(numbers, total)
    calculate_total_recursive(tail, new_total)
  end

  defp calculate_total_recursive([], total), do: total

  defp calculate_sum([head | [next | _]], total) do
    value = head <> next
    String.to_integer(value) + total
  end

  defp calculate_sum([head | _], total) do
    value = head <> head
    String.to_integer(value) + total
  end

  defp calculate_sum([], total), do: total

  defp extract_numbers(<<ascii_code::utf8>> = char, {numbers, letters}) do
    case char do
      _ when ascii_code > 48 and ascii_code <= 57 ->
        number = [ascii_code] |> List.to_string()
        update_numbers(letters, numbers, number)

      word ->
        new_letters = letters <> word

        match =
          new_letters
          |> String.replace(
            ~r/(one|two|three|four|five|six|seven|eight|nine)\b/,
            &replace_word_with_number/1
          )
          |> String.replace(~r/\D/, "")

        case match do
          "" -> {numbers, new_letters}
          number -> remove_third_to_last_letter(new_letters) |> update_numbers(numbers, number)
        end
    end
  end

  def remove_third_to_last_letter(string) do
    String.slice(string, 0..-4) <> String.slice(string, -2..-1)
  end

  def replace_word_with_number(match) do
    Map.get(@word_to_number_map, String.downcase(match), match)
  end

  defp update_numbers(letters, numbers, number) do
    case length(numbers) do
      _ when length(numbers) < 2 -> add_number_to_numbers(numbers, number, letters)
      _ -> replace_last_number_in_numbers(numbers, number, letters)
    end
  end

  defp add_number_to_numbers(numbers, number, letters), do: {numbers ++ [number], letters}

  defp replace_last_number_in_numbers(numbers, number, letters),
    do: {List.delete_at(numbers, -1) ++ [number], letters}
end
