defmodule ReportsGenerator do
  alias ReportsGenerator.Parser

  @options [:users, :foods]

  def build(filename) do
    filename
    |> Parser.parse_file()
    |> Enum.reduce(get_accumulator(), fn line, acc ->
      sum_values(line, acc)
    end)
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
