defmodule BrainTonic.Matrix do
  @moduledoc """
  Performs operations on matrices
  """

  alias BrainTonic.Vector

  @doc """
  Adds two matrices
  """
  @spec add([[number]], [[number]]) :: []
  def add(first, second) do
    Stream.zip(first, second)
      |> Enum.map(fn({x, y}) -> Vector.add(x,y) end)
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
  Creates a new matrix with values provided by the given function
  """
  def build(rows, columns, function) do
    Stream.unfold(rows, fn
      0 -> nil
      n -> {Vector.build(columns, function), n - 1}
    end)
    |> Enum.to_list
  end

  @doc """
  Matrix multiplication
  """
  @spec dot([[]], [[]]) :: [[]]
  def dot(first, second) do
    second_transposed = transpose(second)
    Enum.map(first, fn (row) ->
      Enum.map(second_transposed, &Vector.dot_product(row, &1))
    end)
  end

  @doc """
  Elementwise multiplication of two matrices
  """
  @spec multiply([[]], [[]]) :: [[]]
  def multiply(first, second) do
    Stream.zip(first, second)
      |> Enum.map(fn({x, y}) -> Vector.multiply(x,y) end)
  end

  @doc """
  Elementwise multiplication of a scalar
  """
  @spec multiply_with_scalar([[]], [[]]) :: [[]]
  def multiply_with_scalar(matrix, scalar) do
    Enum.map(matrix, fn (row) ->
      Vector.multiply_with_scalar(row, scalar)
    end)
  end

  @doc """
  Substracts two matrices
  """
  @spec substract([[number]], [[number]]) :: []
  def substract(first, second) do
    Stream.zip(first, second)
      |> Enum.map(fn({x, y}) -> Vector.substract(x,y) end)
  end

  @doc """
  Transposes a matrix
  """
  @spec transpose([[]]) :: [[]]
  def transpose([[]|_]), do: []
  def transpose(matrix) do
    [Enum.map(matrix, &hd(&1)) | transpose(Enum.map(matrix, &tl(&1)))]
  end
end
