defmodule ReportsGenerator do
  alias ReportsGenerator.Parser

  def build(filename) do
    filename
    |> Parser.parse_file
    |> Enum.reduce(%{}, fn line, report ->
      sum_values(line, report)
    end)
  end

  defp sum_values([id, _food_name, price], report) do
    Map.put(report, id, get_sum({report[id], price}))
  end

  defp get_sum({nil, new}), do: new
  defp get_sum({previous, new}), do: previous + new
end
