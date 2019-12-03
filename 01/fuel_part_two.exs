defmodule Fuel do
  def calculate_fuel() do
    total_fuel = read_input()
    |> parse_input()
    |> Enum.reduce(0, fn weight, sum -> sum + fuel_for_weight(weight) end)

    IO.puts "Total fuel required: #{total_fuel}"
  end

  def fuel_for_weight(weight) when weight > 0 do
    fuel = max(div(weight, 3) - 2, 0)
    fuel + fuel_for_weight(fuel)
  end

  def fuel_for_weight(weight), do: 0

  def read_input() do
    File.read!("module_masses.txt")
  end

  def parse_input(input) do
    input
    |> String.trim()
    |> String.split("\n")
    |> Enum.map(fn weight -> String.to_integer(weight) end)
  end
end

Fuel.calculate_fuel()

