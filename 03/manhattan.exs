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
    wire_points = Enum.map(wires, fn wire ->
      build_wire_points(wire)
      |> MapSet.new()
    end)

    intersection_points = Enum.reduce(wire_points, fn wire, intersection_points ->
      MapSet.intersection(intersection_points, wire)
    end)

    find_closest_point(intersection_points)
  end

  def build_wire_points(wire) do
    Enum.reduce(wire, [], fn segment, previous_points ->
      parsed_segment = parse_segment(segment)
      points = build_segment_points(List.first(previous_points) || {0, 0}, parsed_segment)
      List.first(previous_points)
      Enum.reverse(points) ++ previous_points
    end)
  end

  def build_segment_points({start_x, start_y}, {@right, distance}) do
    Enum.map(0..distance, fn cur_distance -> {start_x + cur_distance, start_y} end)
  end

  def build_segment_points({start_x, start_y}, {@left, distance}) do
    Enum.map(0..distance, fn cur_distance -> {start_x - cur_distance, start_y} end)
  end

  def build_segment_points({start_x, start_y}, {@up, distance}) do
    Enum.map(0..distance, fn cur_distance -> {start_x, start_y + cur_distance} end)
  end

  def build_segment_points({start_x, start_y}, {@down, distance}) do
    Enum.map(0..distance, fn cur_distance -> {start_x, start_y - cur_distance} end)
  end

  # Returns {direction, distance}
  def parse_segment(segment) do
    {direction, distance} = String.split_at(segment, 1)
    {direction, String.to_integer(distance)}
  end

  # Finds the closest point to the origin, which is 0, 0
  def find_closest_point(%MapSet{} = points) do
    Enum.reduce(points, fn point, lowest_distance ->
      distance = point_distance(point)
      case distance do
        0 -> lowest_distance
        _ -> min(lowest_distance, distance)
      end
    end)
  end

  def point_distance({x, y}), do: abs(x) + abs(y)
end

Input.read_file("directions.txt")
|> Input.parse_file()
|> Manhattan.calculate_distance()
|> IO.puts




