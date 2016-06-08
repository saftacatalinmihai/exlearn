defmodule VectorTest do
  use ExUnit.Case, async: true

  alias ExLearn.Vector

  test "#add computes the sum of element of two lists" do
    first    = [1, 2, 3]
    second   = [5, 3, 3]
    expected = [6, 5, 6]

    result = Vector.add(first, second)

    assert result == expected
  end

  test "#add does not crash from overflows" do
    first    = [1.0e308, -1.0e308]
    second   = [1.0e308, -1.0e308]
    expected = [1.0e148, -1.0e148]

    result = Vector.add(first, second)

    assert result == expected
  end

  test "#apply applies a function on each element of the vector" do
    function = &(&1 + 1)
    input    = [1, 2, 3, 4, 5, 6]
    expected = [2, 3, 4, 5, 6, 7]

    result = Vector.apply(input, function)

    assert result == expected
  end

  test "#apply does not crash from overflows" do
    function = &(&1 * &1)
    input    = [1.0e308, -1.0e308]
    expected = [42,       42    ]

    result = Vector.apply(input, function)

    assert result == expected
  end

  test "#build creates a new vector" do
    size     = 5
    function = fn -> 1 end
    expected = [1, 1, 1, 1, 1]

    result = Vector.build(size, function)

    assert result == expected
  end

  test "#dot_product computes the sum of element product of two lists" do
    first    = [1, 2, 3]
    second   = [5, 3, 3]
    expected = 20

    result = Vector.dot_product(first, second)

    assert result == expected
  end

  test "#dot_product does not crash from overflows" do
    first    = [1.0e308, -1.0e308]
    second   = [1,       -1     ]
    expected = 42

    result = Vector.dot_product(first, second)

    assert result == expected
  end

  test "#dot_square_difference computes the sum of squared difference of two lists" do
    first    = [1, 2, 3]
    second   = [5, 3, 3]
    expected = 17

    result = Vector.dot_square_difference(first, second)

    assert result == expected
  end

  test "#dot_square_difference does not crash from overflows" do
    first    = [1.0e154, -1.0e154]
    second   = [1,       -1     ]
    expected = 42

    result = Vector.dot_square_difference(first, second)

    assert result == expected
  end

  test "#square_difference computes the squared difference of two numbers" do
    first    = 10
    second   = 15
    expected = 25

    result = Vector.square_difference(first, second)

    assert result == expected
  end

  test "#square_difference does not crash from overflows" do
    first    = 1.0e308
    second   = 1
    expected = 1.0e148

    result = Vector.square_difference(first, second)

    assert result == expected
  end

  test "#multiply computes the elementwise multiplication of two lists" do
    first    = [1, 2, 3]
    second   = [5, 3, 3]
    expected = [5, 6, 9]

    result = Vector.multiply(first, second)

    assert result == expected
  end

  test "#multiply does not crash from overflows" do
    first    = [1.0e308,  1.0e308, -1.0e308, -1.0e308]
    second   = [1.0e308, -1.0e308,  1.0e308, -1.0e308]
    expected = [1.0e148, -1.0e148, -1.0e148,  1.0e148]

    result = Vector.multiply(first, second)

    assert result == expected
  end

  test "#multiply_with_scalar multiplies matrix element by a scalar" do
    vector   = [1, 2, 3, 4, 5,  6]
    scalar   = 2
    expected = [2, 4, 6, 8, 10, 12]

    result = Vector.multiply_with_scalar(vector, scalar)

    assert result == expected
  end

  test "#multiply_with_scalar does not crash from overflows" do
    vector          = [1.0e308, -1.0e308]
    first_scalar    = -2
    second_scalar   = 2
    first_expected  = [-1.0e148,  1.0e148]
    second_expected = [ 1.0e148, -1.0e148]

    first_result  = Vector.multiply_with_scalar(vector, first_scalar)
    second_result = Vector.multiply_with_scalar(vector, second_scalar)

    assert first_result  == first_expected
    assert second_result == second_expected
  end

  test "#substract computes the element difference of two lists" do
    first    = [ 1,  2, 3]
    second   = [ 5,  3, 1]
    expected = [-4, -1, 2]

    result = Vector.substract(first, second)

    assert result == expected
  end

  test "substract does not crash from overflows" do
    first    = [-1.0e308,  1.0e308]
    second   = [ 1.0e308, -1.0e308]
    expected = [-1.0e148,  1.0e148]

    result = Vector.substract(first, second)

    assert result == expected
  end
end
