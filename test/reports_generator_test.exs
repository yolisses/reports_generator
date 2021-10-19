defmodule ReportsGeneratorTest do
  use ExUnit.Case

  describe "build/1" do
    test "builds the report" do
      file_name = "report_test.csv"

      expected = %{
        foods: %{
          "açaí" => 1,
          "churrasco" => 2,
          "esfirra" => 3,
          "hambúrguer" => 2,
          "pizza" => 2
        },
        users: %{
          "1" => 48,
          "10" => 36,
          "2" => 45,
          "3" => 31,
          "4" => 42,
          "5" => 49,
          "6" => 18,
          "7" => 27,
          "8" => 25,
          "9" => 24
        }
      }

      response = ReportsGenerator.build(file_name)

      assert response == expected
    end
  end

  describe "fetch_higher_cost/2" do
    test "when the option is :users, return the user who spent the the most" do
      file_name = "report_test.csv"

      expected = {:ok, {"5", 49}}

      response =
        file_name
        |> ReportsGenerator.build()
        |> ReportsGenerator.fetch_higher_cost(:users)

      assert response == expected
    end

    test "when the option is :foods, return the most consumed food" do
      file_name = "report_test.csv"

      expected = {:ok, {"esfirra", 3}}

      response =
        file_name
        |> ReportsGenerator.build()
        |> ReportsGenerator.fetch_higher_cost(:foods)

      assert response == expected
    end

    test "when the option is invalid, returns a error" do
      file_name = "report_test.csv"

      expected = {:error, "Invalid opiton!"}

      response =
        file_name
        |> ReportsGenerator.build()
        |> ReportsGenerator.fetch_higher_cost("massa")

      assert response == expected
    end
  end
end
