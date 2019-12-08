defmodule Day1 do
  def solve do
    masses = read_input('input')
    Enum.reduce(masses, 0, fn mass, acc -> Fuel.amount_required(mass) + acc end)
  end

  def read_input(path) do
    File.stream!(path)
    |> Enum.map(&String.trim/1)
    |> Enum.map(&Integer.parse/1)
    |> Enum.map(&Kernel.elem(&1, 0))
  end
end

defmodule Fuel do
  def amount_required(mass) when mass <= 0 do
    0
  end

  def amount_required(mass) do
    fuel_required = max(floor(mass / 3) - 2, 0)
    fuel_for_fuel = Fuel.amount_required(fuel_required)
    fuel_required + fuel_for_fuel
  end
end
