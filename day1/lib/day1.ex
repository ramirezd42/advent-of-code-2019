defmodule Day1 do
  def load_modules(path) do
    File.stream!(path)
    |> Enum.map(&String.trim/1)
    |> Enum.map(&Integer.parse/1)
    |> Enum.map(&Kernel.elem(&1, 0))
    |> count_fuel
  end

  def count_fuel(modules) do
    Enum.reduce(modules, 0, fn mass, acc -> count_module(mass) + acc end)
  end

  def count_module(mass) do
    floor(mass / 3) - 2
  end
end
