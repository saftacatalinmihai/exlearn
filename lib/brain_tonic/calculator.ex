defmodule BrainTonic.Calculator do
  @moduledoc """
  Performs operations on matrices
  """

  @doc """
  Adds a list to the row of a 1:n matrix
  """
  @spec add([[]], []) :: []
  def add([first], second) do
    [
      Stream.zip(first, second)
      |> Enum.map(fn({x, y}) -> x + y end)
    ]
  end

  @doc """
  Element-wise list substraction
  """
  @spec substract([], []) :: []
  def substract(first, second) do
    Stream.zip(first, second)
    |> Enum.map(fn({x, y}) -> x - y end)
  end

  @doc """
  Applies the given function on each element of the matrix
  """
  @spec apply([[]], ((number) -> number)) :: [[]]
  def apply(matrix, function) do
    Enum.map(matrix, fn (row) ->
      Enum.map(row, &function.(&1))
    end)
  end

  @doc """
  Multiplies two matrices
  """
  @spec multiply([[]], [[]]) :: [[]]
  def multiply(first, second) do
    second_transposed = transpose(second)

    Enum.map(first, fn(row)->
      Enum.map(second_transposed, &dot_product(row, &1))
    end)
  end

  def transpose([[]|_]), do: []
  def transpose(matrix) do
    [Enum.map(matrix, &hd(&1)) | transpose(Enum.map(matrix, &tl(&1)))]
  end

  @spec dot_product([number], [number]) :: number
  def dot_product(first, second) do
    Stream.zip(first, second)
    |> Enum.map(fn({x, y}) -> x * y end)
    |> Enum.sum
  end

  @spec dot_square_diff([number], [number]) :: number
  def dot_square_diff(first, second) do
    Stream.zip(first, second)
    |> Enum.map(fn({x, y}) -> (x - y) * (x - y) end)
    |> Enum.sum
  end
end
