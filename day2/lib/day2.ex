defmodule Day2 do
  def solve do
    mem = Program.import_program('input')
    mem = List.replace_at(mem, 1, 12)
    mem = List.replace_at(mem, 2, 2)
    Program.execute_program(mem)
  end
end

defmodule Program do
  def import_program(path) do
    file = File.read!(path)

    String.split(file, ",")
    |> Enum.map(&Integer.parse/1)
    |> Enum.map(&Kernel.elem(&1, 0))
  end

  def execute_program(mem) do
    stream =
      Stream.unfold({0, mem}, fn {cursor, mem} ->
        op_code = if cursor >= 0, do: Enum.at(mem, cursor), else: nil

        case op_code do
          nil -> nil
          99 -> {Enum.at(mem, 0), {-1, mem}}
          _ -> {Enum.at(mem, 0), {cursor + 4, Program.execute_operation(cursor, mem)}}
        end
      end)

    Enum.reduce(stream, fn val, _ -> val end)
  end

  def execute_operation(cursor, mem) do
    opcode = Enum.at(mem, cursor)
    lhs = Enum.at(mem, Enum.at(mem, cursor + 1))
    rhs = Enum.at(mem, Enum.at(mem, cursor + 2))
    store_at = Enum.at(mem, cursor + 3)
    value = Instruction.evaluate(opcode, lhs, rhs)
    mem = List.replace_at(mem, store_at, value)
    mem
  end
end

defmodule Instruction do
  def evaluate(1, lhs, rhs) do
    lhs + rhs
  end

  def evaluate(2, lhs, rhs) do
    lhs * rhs
  end
end
