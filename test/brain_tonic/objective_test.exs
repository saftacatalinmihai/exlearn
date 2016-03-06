defmodule ObjectiveTest do
  use ExUnit.Case, async: true

  alias BrainTonic.Objective

  test "#determine return the give function pair" do
    first  = 1
    second = 2

    expected_from_function   = 4
    expected_from_derivative = 5

    given_function   = &(&1 + &2 + 1)
    given_derivative = &(&1 + &2 + 2)

    setup = %{function: given_function, derivative: given_derivative}

    %{function: function, derivative: derivative} = Objective.determine(setup)

    assert function.(first, second)   == expected_from_function
    assert derivative.(first, second) == expected_from_derivative
  end

  test "#determine return the quadratic function pair" do
    first    = [1, 2, 3]
    second   = [1, 2, 7]

    expected_from_function   = 8
    expected_from_derivative = [0, 0, 4]

    setup = :quadratic

    %{function: function, derivative: derivative} = Objective.determine(setup)

    assert function.(first, second)   == expected_from_function
    assert derivative.(first, second) == expected_from_derivative
  end
end
