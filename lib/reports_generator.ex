defmodule ReportsGenerator do
  def build(filename) do
    "reports/#{filename}"
    |> File.stream!
    |> Enum.reduce(%{}, fn(line, report) ->
      [id, _food_name, price] = parse_line(line)
      Map.put(report, id, get_sum({report[id], price}) || 0)
    end)
  end

  defp get_sum({nil, new}), do: new
  defp get_sum({previous, new}), do: previous + new

  defp parse_line(line) do
    line
    |> String.trim
    |> String.split(",")
    |> List.update_at(2, &String.to_integer/1)
  end
end
