defmodule ActivationTest do
  use ExUnit.Case, async: true

  alias BrainTonic.Activation

  test "#determine return the give function pair" do
    argument = 1

    expected_from_function   = 2
    expected_from_derivative = 3

    given_function   = &(&1 + 1)
    given_derivative = &(&1 + 2)

    setup = %{function: given_function, derivative: given_derivative}

    %{function: function, derivative: derivative} = Activation.determine(setup)

    assert function.(argument)   == expected_from_function
    assert derivative.(argument) == expected_from_derivative
  end

  test "#determine return the quadratic function pair" do
    argument = 10

    expected_from_function   = 10
    expected_from_derivative = 1

    setup = :identity

    %{function: function, derivative: derivative} = Activation.determine(setup)

    assert function.(argument)   == expected_from_function
    assert derivative.(argument) == expected_from_derivative
  end
end
