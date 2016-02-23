defmodule CalculatorTest do
  use ExUnit.Case, async: true

  alias BrainTonic.Calculator

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

  test "#add adds two lists" do
    first  = [1, 2, 3]
    second = [4, 5, 6]

    expected = [5, 7, 9]

    [result] = Calculator.add([first], second)

    assert length(result) == length(second)
    Enum.with_index(result)
    |> Enum.each(fn ({element, index}) ->
      assert element == Enum.at(expected, index)
    end)
  end

  test "#multiply multiplies two matrices" do
    first  = [[1, 2, 3], [4, 5, 6]]
    second = [[1, 2], [3, 4], [5, 6]]

    expected = [[22, 28], [49, 64]]

    Calculator.multiply(first, second)
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
