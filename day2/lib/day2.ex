defmodule Day2 do
  def solve do
    mem = IntcodeComputer.import_program('input')
    mem = List.replace_at(mem, 1, 12)
    mem = List.replace_at(mem, 2, 2)
    IntcodeComputer.execute_program(mem)
  end
end

defmodule IntcodeComputer do
  def import_program(path) do
    file = File.read!(path)

    String.split(file, ",")
    |> Enum.map(&Integer.parse/1)
    |> Enum.map(&Kernel.elem(&1, 0))
  end

  def execute_program(mem) do
    stream =
      Stream.unfold({0, mem}, fn {instruction_pointer, mem} ->
        op_code = if instruction_pointer >= 0, do: Enum.at(mem, instruction_pointer), else: nil

        case op_code do
          nil -> nil
          99 -> {Enum.at(mem, 0), {-1, mem}}
          _ -> {Enum.at(mem, 0), {instruction_pointer + 4, execute_instruction(instruction_pointer, mem)}}
        end
      end)

    Enum.reduce(stream, fn val, _ -> val end)
  end

  def execute_instruction(instruction_pointer, mem) do
    opcode = Enum.at(mem, instruction_pointer)
    lhs = Enum.at(mem, Enum.at(mem, instruction_pointer + 1))
    rhs = Enum.at(mem, Enum.at(mem, instruction_pointer + 2))
    storage_address = Enum.at(mem, instruction_pointer + 3)
    value = evaluate_operation(opcode, lhs, rhs)
    mem = List.replace_at(mem, storage_address, value)
    mem
  end

  def evaluate_operation(1, lhs, rhs) do
    lhs + rhs
  end

  def evaluate_operation(2, lhs, rhs) do
    lhs * rhs
  end
end

