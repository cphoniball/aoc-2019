defmodule Input do
  def read_file(path) do
    File.read!(path)
  end

  # Split the file string into an array of arrays, where the outer array is a wire
  # and the inner array is a list of directions in the wire
  def parse_file(contents) do
    contents
    |> String.trim()
    |> String.split("\n")
    |> Enum.map(fn line -> String.split(line, ",") end)
  end
end

defmodule Manhattan do
  @right "R"
  @left "L"
  @up "U"
  @down "D"

  # Wires will be an array of arrays, where the outer array is a wire
  # and an inner array is the list of segments of that wire, in order
  def calculate_distance(wires) do
    [wire_one, wire_two] = Enum.map(wires, fn wire ->
      build_wire_points(wire)
    end)

    intersection_distances(wire_one, wire_two)
    |> Enum.map(fn {one, two} -> one + two end)
    |> Enum.filter(fn distance -> distance > 0 end)
    |> Enum.min()
  end

  def build_wire_points(wire) do
    Enum.reduce(wire, [], fn segment, previous_points ->
      parsed_segment = parse_segment(segment)
      points = build_segment_points(List.first(previous_points) || {0, 0, 0}, parsed_segment)
      Enum.reverse(points) ++ previous_points
    end)
  end

  def build_segment_points({start_x, start_y, steps}, {@right, distance}) do
    Enum.map(0..distance, fn cur_distance -> {start_x + cur_distance, start_y, steps + cur_distance} end)
  end

  def build_segment_points({start_x, start_y, steps}, {@left, distance}) do
    Enum.map(0..distance, fn cur_distance -> {start_x - cur_distance, start_y, steps + cur_distance} end)
  end

  def build_segment_points({start_x, start_y, steps}, {@up, distance}) do
    Enum.map(0..distance, fn cur_distance -> {start_x, start_y + cur_distance, steps + cur_distance} end)
  end

  def build_segment_points({start_x, start_y, steps}, {@down, distance}) do
    Enum.map(0..distance, fn cur_distance -> {start_x, start_y - cur_distance, steps + cur_distance} end)
  end

  # Returns {direction, distance}
  def parse_segment(segment) do
    {direction, distance} = String.split_at(segment, 1)
    {direction, String.to_integer(distance)}
  end

  # Takes a wire as a list of points, and converts it to a map where
  # each key is of form "#{x},#{y}": distance
  def wire_to_map(wire) do
    Map.new(wire, fn {x, y, distance} -> {"#{x},#{y}", distance} end)
  end

  def intersection_distances(wire_one, wire_two) do
    wire_one_map = wire_to_map(wire_one)
    wire_two_map = wire_to_map(wire_two)

    wire_one_map
    |> Map.keys()
    |> Enum.reduce([], fn wire_key, intersection_points ->
      case Map.fetch(wire_two_map, wire_key) do
        {:ok, point_two} -> intersection_points ++ [{wire_one_map[wire_key], point_two}]
        :error -> intersection_points
      end
    end)
  end
end

Input.read_file("directions.txt")
|> Input.parse_file()
|> Manhattan.calculate_distance()
|> IO.puts




