

defmodule Input do
  def read_file(path) do
    File.read!(path)
  end

  def parse_file_to_map(contents) do
    String.split(contents, ",")
    |> Enum.map(fn number -> String.to_integer(String.trim(number)) end)
  end
end

defmodule Intcode do
  @add 1
  @multiply 2
  @stop 99

  def calculate(integers, cur_index \\ 0) when is_list(integers) do
    case get_opcode(integers, cur_index) |> calculate_opcode(integers) do
      {:ok, integers} -> calculate(integers, cur_index + 4)
      {:stop, integers} -> integers
    end
  end

  def get_opcode(integers, cur_index) do
    [
      Enum.at(integers, cur_index),
      Enum.at(integers, cur_index + 1),
      Enum.at(integers, cur_index + 2),
      Enum.at(integers, cur_index + 3),
    ]
  end

  def calculate_opcode([one, two, three, four], integers) when one == @add do
    sum = Enum.at(integers, two) + Enum.at(integers, three)
    {:ok, List.replace_at(integers, four, sum)}
  end

  def calculate_opcode([one, two, three, four], integers) when one == @multiply do
    product = Enum.at(integers, two) * Enum.at(integers, three)
    {:ok, List.replace_at(integers, four, product)}
  end

  def calculate_opcode([one, _, _, _], integers) when one == @stop do
    {:stop, integers}
  end
end

result = Input.read_file("integers.txt") |> Input.parse_file_to_map() |> Intcode.calculate
IO.inspect result
