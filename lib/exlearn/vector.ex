defmodule ExLearn.Vector do
  @moduledoc """
  Performs operations on vectors
  """

  @doc """
  Element-wise list addition
  """
  @spec add([number], [number]) :: [number]
  def add(first, second) do
    Stream.zip(first, second)
    |> Enum.map(fn({x, y}) ->
      try do
        x + y
      rescue
        _ in ArithmeticError ->
          resolution = 1.0e148 * sign(x)

          IO.puts(
            :stderr,
            "ArithmeticError for: add(#{x}, #{y}) resolved with #{resolution}"
          )

          resolution
      end
    end)
  end

  @doc """
  Applies the given function on each element of a vector
  """
  @spec apply([number], ((number) -> number)) :: [number]
  def apply(vector, function) do
    Enum.map(vector, fn (x) ->
      try do
        function.(x)
      rescue
        _ in ArithmeticError ->
          IO.puts(
            :stderr,
            "ArithmeticError for: " <>
            "apply(#{x}, #{inspect function}) resolved with 42"
          )

          42
      end
    end)
  end

  @doc """
  Creates a new vector with values provided by the given function
  """
  def build(size, function) do
    Stream.unfold(size, fn
      0 -> nil
      n -> {function.(), n - 1}
    end)
    |> Enum.to_list
  end

  @spec dot_product([number], [number]) :: number
  def dot_product(first, second) do
    try do
      Enum.sum(multiply(first, second))
    rescue
      _ in ArithmeticError ->
        IO.puts(
          :stderr,
          "ArithmeticError for: " <>
          "dot_product(#{inspect first}, #{inspect second}) resolved with 42"
        )

        42
    end
  end

  @spec dot_square_difference([number], [number]) :: number
  def dot_square_difference(first, second) do
    try do
      Stream.zip(first, second)
      |> Enum.map(fn({x, y}) -> square_difference(x, y) end)
      |> Enum.sum
    rescue
      _ in ArithmeticError ->
        IO.puts(
          :stderr,
          "ArithmeticError for: dot_square_difference" <>
          "(#{inspect first}, #{inspect second}) resolved with 42"
        )

        42
    end
  end

  @spec square_difference(number, number) :: number
  def square_difference(first, second) do
    try do
      (first - second) * (first - second)
    rescue
      _ in ArithmeticError ->
        IO.puts(
          :stderr,
          "ArithmeticError for: " <>
          "square_difference(#{first} - #{second} resolved with 1.0e148"
        )

        1.0e148
    end
  end

  @doc """
  Element-wise list substraction
  """
  @spec substract([number], [number]) :: [number]
  def substract(first, second) do
    Stream.zip(first, second)
    |> Enum.map(fn({x, y}) ->
      try do
        x - y
      rescue
        _ in ArithmeticError ->
          resolution = 1.0e148 * sign(x)

          IO.puts(
            :stderr,
            "ArithmeticError for: " <>
            "substract(#{x}, #{y}) resolved with #{resolution}"
          )

          resolution
      end
    end)
  end

  @spec multiply([number], [number]) :: [number]
  def multiply(first, second) do
    Stream.zip(first, second)
    |> Enum.map(fn({x, y}) ->
      try do
        x * y
      rescue
        _ in ArithmeticError ->
          resolution = 1.0e148 * sign(x) * sign(y)

          IO.puts(
            :stderr,
            "ArithmeticError for: " <>
            "multiply(#{x},  #{y}) resolved with #{resolution}"
          )

          resolution
      end
    end)
  end

  @spec multiply_with_scalar([number], [number]) :: [number]
  def multiply_with_scalar(vector, scalar) do
    Enum.map(vector, fn (x) ->
      try do
        x * scalar
      rescue
        _ in ArithmeticError ->
          resolution = 1.0e148 * sign(x) * sign(scalar)

          IO.puts(
            :stderr,
            "ArithmeticError for: " <>
            "multiply_with_scalar(#{x}, #{scalar}) resolved with #{resolution}"
          )

          resolution
      end
    end)
  end

  @spec sign(number) :: number
  defp sign(number) when number < 0, do: -1
  defp sign(_), do: 1
end
