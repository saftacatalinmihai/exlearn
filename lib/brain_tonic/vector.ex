defmodule BrainTonic.Vector do
  @moduledoc """
  Performs operations on vectors
  """

  @doc """
  Element-wise list addition
  """
  @spec add([number], [number]) :: [number]
  def add(first, second) do
    Stream.zip(first, second)
    |> Enum.map(fn({x, y}) -> x + y end)
  end

  @doc """
  Applies the given function on each element of a vector
  """
  @spec apply([number], ((number) -> number)) :: [number]
  def apply(vector, function) do
    Enum.map(vector, &function.(&1))
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
    Enum.sum(multiply(first, second))
  end

  @spec dot_square_difference([number], [number]) :: number
  def dot_square_difference(first, second) do
    Stream.zip(first, second)
    |> Enum.map(fn({x, y}) -> (x - y) * (x - y) end)
    |> Enum.sum
  end

  @doc """
  Element-wise list substraction
  """
  @spec substract([number], [number]) :: [number]
  def substract(first, second) do
    Stream.zip(first, second)
    |> Enum.map(fn({x, y}) -> x - y end)
  end

  @spec multiply([number], [number]) :: [number]
  def multiply(first, second) do
    Stream.zip(first, second)
    |> Enum.map(fn({x, y}) -> x * y end)
  end
end
