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
  def has_same_adjacents(password) do
    if String.length(password) == 1 do
      false
    else
      case String.at(password, 0) == String.at(password, 1) do
        true -> true
        false -> has_same_adjacents(string_without_first(password))
      end
    end
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
end

IO.puts Password.digits_increase("111111")

153517..630395
|> Password.possible_passwords()
|> IO.inspect()
|> Enum.count()
|> IO.puts()
