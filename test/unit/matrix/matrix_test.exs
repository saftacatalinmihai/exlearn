defmodule MatrixTest do
  use ExUnit.Case, async: true

  alias BrainTonic.Matrix

  test "#apply applies a function on each element of the matrix" do
    function = &(&1 + 1)
    matrix   = [[1, 2, 3], [4, 5, 6]]

    Matrix.apply(matrix, function)
    |> Enum.with_index
    |> Enum.each(fn ({list, row}) ->
      list
      |> Enum.with_index
      |> Enum.each(fn ({element, column}) ->
        current = Enum.at(Enum.at(matrix, row), column)
        application = function.(current)
        assert element == application
      end)
    end)
  end

  test "#multiply multiplies two matrixes" do
    first  = [[1, 2, 3], [4, 5, 6]]
    second = [[1, 2], [3, 4], [5, 6]]

    expected = [[22, 28], [49, 64]]

    Matrix.multiply(first, second)
    |> Enum.with_index
    |> Enum.each(fn ({list, row}) ->
      list
      |> Enum.with_index
      |> Enum.each(fn ({element, column}) ->
        current = Enum.at(Enum.at(expected, row), column)
        assert element == current
      end)
    end)
  end
end
