defmodule Day1.Trebuchet do
  def calculate_total_calibration(input) do
    recursive_calculate(input, 0)
  end

  defp recursive_calculate([head | tail], total) do
    list = String.graphemes(head)

    result =
      Enum.reduce(list, [], &extract_numbers/2)
      |> calculate_sum(total)

    recursive_calculate(tail, result)
  end

  defp recursive_calculate([], sum), do: sum

  defp calculate_sum([head | [tail | _]], total) do
    calibration_value = head <> tail
    String.to_integer(calibration_value) + total
  end

  defp calculate_sum([head | _], total) do
    calibration_value = head <> head
    String.to_integer(calibration_value) + total
  end

  defp calculate_sum([], total), do: total

  defp extract_numbers(<<ascii_code::utf8>>, acc) when ascii_code >= 48 and ascii_code <= 57 do
    number = [ascii_code] |> List.to_string()

    case length(acc) do
      _ when length(acc) < 2 -> add_number_to_acc(acc, number)
      _ -> replace_last_number_in_acc(acc, number)
    end
  end

  defp extract_numbers(_, acc), do: acc

  defp add_number_to_acc(acc, number), do: acc ++ [number]

  defp replace_last_number_in_acc(acc, number), do: List.delete_at(acc, -1) ++ [number]
end
