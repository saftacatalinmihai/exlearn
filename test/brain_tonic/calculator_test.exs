defmodule CalculatorTest do
  use ExUnit.Case, async: true

  alias BrainTonic.Calculator

  test "#add adds two lists" do
    first    = [1, 2, 3]
    second   = [4, 5, 6]
    expected = [5, 7, 9]

    [result] = Calculator.add([first], second)

    assert length(result) == length(second)
    Enum.with_index(result)
    |> Enum.each(fn ({element, index}) ->
      assert element == Enum.at(expected, index)
    end)
  end

  test "#apply applies a function on each element of the matrix" do
    function = &(&1 + 1)
    matrix   = [[1, 2, 3], [4, 5, 6]]

    Calculator.apply(matrix, function)
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

  test "#dot_product computes the sum of element product of two lists" do
    first    = [1, 2, 3]
    second   = [5, 3, 3]
    expected = 20

    result = Calculator.dot_product(first, second)

    assert result == expected
  end

  test "#dot_square_diff computes the sum of squared difference of two lists" do
    first    = [1, 2, 3]
    second   = [5, 3, 3]
    expected = 17

    result = Calculator.dot_square_diff(first, second)

    assert result == expected
  end

  test "#multiply multiplies two matrices" do
    first  = [[1, 2, 3], [4, 5, 6]]
    second = [[1, 2], [3, 4], [5, 6]]

    expected = [[22, 28], [49, 64]]

    result = Calculator.multiply(first, second)

    assert result == expected
  end

  test "#substract computes the element difference of two lists" do
    first    = [1, 2, 3]
    second   = [5, 3, 1]
    expected = [-4, -1, 2]

    result = Calculator.substract(first, second)

    assert result == expected
  end
end
