defmodule MatrixTest do
  use ExUnit.Case, async: true

  alias BrainTonic.Matrix

  @matrix [[1, 2, 3], [4, 5, 6]]

  test "#apply applies a function on each element of the matrix" do
    function = &(&1 + 1)
    Matrix.apply(@matrix, function)
    |> Enum.with_index
    |> Enum.each(fn ({list, row}) ->
      list
      |> Enum.with_index
      |> Enum.each(fn ({element, column}) ->
        current = Enum.at(Enum.at(@matrix, row), column)
        application = function.(current)
        assert element == application
      end)
    end)
  end
end
