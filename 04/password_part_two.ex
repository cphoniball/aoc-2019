defmodule Password do
  def possible_passwords(range) do
    Enum.filter(range, fn number ->
      number |> Integer.to_string() |> valid_password?()
    end)
  end

  def valid_password?(password) do
    has_same_adjacents(password) && digits_increase(password)
  end

  # Verifies a password has at least two of the same digits next to each other,
  # e.g. 1234412
  def has_same_adjacents(password, index \\ 0) do
    String.codepoints(password)
    |> Enum.with_index()
    |> Enum.reduce([], fn {codepoint, index}, pairs ->
      case codepoint == String.at(password, index + 1) do
        true -> [{index, index + 1} | pairs]
        false -> pairs
      end
    end)
    |> Enum.reduce(false, fn {start_index, end_index}, valid? ->
      case pair_not_surrounded_by_same(password, {start_index, end_index}) do
        true -> true
        false -> valid?
      end
    end)
  end

  # Verifies a passwords digits only ever go up from left to right
  def digits_increase(password) do
    if String.length(password) == 1 do
      true
    else
      case String.at(password, 0) <= String.at(password, 1) do
        true -> digits_increase(string_without_first(password))
        false -> false
      end
    end
  end

  def string_without_first(string) do
    String.slice(string, 1, String.length(string))
  end

  def pair_not_surrounded_by_same(string, {start_index, end_index}) do
    String.at(string, start_index - 1) != String.at(string, start_index)
    && String.at(string, end_index + 1) != String.at(string, end_index)
  end
end

# Expected answer is 1172
153517..630395
|> Password.possible_passwords()
|> Enum.count()
|> IO.puts()
