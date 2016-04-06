defmodule BrainTonic.Matrix do
  @moduledoc """
  Performs operations on matrices
  """

  alias BrainTonic.Vector

  @doc """
  Adds a list to the row of a 1:n matrix
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
  Multiplies two matrices
  """
  @spec multiply([[]], [[]]) :: [[]]
  def multiply(first, second) do
    second_transposed = transpose(second)

    Enum.map(first, fn (row) ->
      Enum.map(second_transposed, &Vector.dot_product(row, &1))
    end)
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
