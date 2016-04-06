defmodule MatrixTest do
  use ExUnit.Case, async: true

  alias BrainTonic.Matrix

  test "#add adds two matrices" do
    first  = [[1, 2, 3], [4, 5, 6]]
    second = [[5, 2, 1], [3, 4, 6]]

    expected = [[6, 4, 4], [7, 9, 12]]

    result = Matrix.add(first, second)

    assert result == expected
  end

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

  test "#multiply multiplies two matrices" do
    first  = [[1, 2, 3], [4, 5, 6]]
    second = [[1, 2], [3, 4], [5, 6]]

    expected = [[22, 28], [49, 64]]

    result = Matrix.multiply(first, second)

    assert result == expected
  end

  test "#transpose transposes a matrix" do
    input    = [[1, 2, 3], [4, 5, 6]]
    expected = [[1, 4], [2, 5], [3, 6]]

    result = Matrix.transpose(input)

    assert result == expected
  end
end
