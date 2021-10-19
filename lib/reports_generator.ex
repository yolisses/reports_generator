defmodule ReportsGenerator do
  alias ReportsGenerator.Parser

  @options [:users, :foods]

  def build(file_name) do
    file_name
    |> Parser.parse_file()
    |> Enum.reduce(get_accumulator(), fn line, acc ->
      sum_values(line, acc)
    end)
  end

  def build_from_many(file_names) do
    file_names
    |> Task.async_stream(&build/1)
    |> Enum.reduce(get_accumulator(), fn {:ok, result}, report -> sum_reports(report, result) end)
  end

  def sum_reports(%{foods: foods1, users: users1}, %{foods: foods2, users: users2}) do
    %{
      foods: sum_maps_values(foods1, foods2),
      users: sum_maps_values(users1, users2)
    }
  end

  def sum_maps_values(map1, map2) do
    Map.merge(map1, map2, fn _key, value1, value2 -> value1 + value2 end)
  end

  def get_accumulator do
    %{users: %{}, foods: %{}}
  end

  def fetch_higher_cost(report, option) when option in @options do
    {:ok, Enum.max_by(report[option], fn {_key, value} -> value end)}
  end

  def fetch_higher_cost(_, _), do: {:error, "Invalid opiton!"}

  defp sum_values(
         [id, food_name, price],
         %{foods: foods, users: users} = report
       ) do
    users = Map.put(users, id, get_sum({users[id], price}))
    foods = Map.put(foods, food_name, get_sum({foods[food_name], 1}))
    %{report | users: users, foods: foods}
  end

  defp get_sum({nil, new}), do: new
  defp get_sum({previous, new}), do: previous + new
end
