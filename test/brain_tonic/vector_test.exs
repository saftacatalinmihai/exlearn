defmodule VectorTest do
  use ExUnit.Case, async: true

  alias BrainTonic.Vector

  test "#dot_product computes the sum of element of two lists" do
    first    = [1, 2, 3]
    second   = [5, 3, 3]
    expected = [6, 5, 6]

    result = Vector.add(first, second)

    assert result == expected
  end

  test "#dot_product computes the sum of element product of two lists" do
    first    = [1, 2, 3]
    second   = [5, 3, 3]
    expected = 20

    result = Vector.dot_product(first, second)

    assert result == expected
  end

  test "#dot_square_diff computes the sum of squared difference of two lists" do
    first    = [1, 2, 3]
    second   = [5, 3, 3]
    expected = 17

    result = Vector.dot_square_diff(first, second)

    assert result == expected
  end

  test "#substract computes the element difference of two lists" do
    first    = [1, 2, 3]
    second   = [5, 3, 1]
    expected = [-4, -1, 2]

    result = Vector.substract(first, second)

    assert result == expected
  end
end
