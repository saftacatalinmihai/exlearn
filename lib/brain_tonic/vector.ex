defmodule BrainTonic.Vector do
  @moduledoc """
  Performs operations on vectors
  """

  @doc """
  Element-wise list addition
  """
  @spec add([number], [number]) :: []
  def add(first, second) do
    Stream.zip(first, second)
    |> Enum.map(fn({x, y}) -> x + y end)
  end

  @doc """
  Element-wise list substraction
  """
  @spec substract([number], [number]) :: []
  def substract(first, second) do
    Stream.zip(first, second)
    |> Enum.map(fn({x, y}) -> x - y end)
  end

  @spec dot_product([number], [number]) :: number
  def dot_product(first, second) do
    Enum.sum(hadamard(first, second))
  end

  @spec hadamard([number], [number]) :: [number]
  def hadamard(first, second) do
    Stream.zip(first, second)
    |> Enum.map(fn({x, y}) -> x * y end)
  end

  @spec dot_square_diff([number], [number]) :: number
  def dot_square_diff(first, second) do
    Stream.zip(first, second)
    |> Enum.map(fn({x, y}) -> (x - y) * (x - y) end)
    |> Enum.sum
  end
end
