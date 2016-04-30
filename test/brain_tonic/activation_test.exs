defmodule ActivationTest do
  use ExUnit.Case, async: true

  alias BrainTonic.Activation

  test "#determine a given function pair" do
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

  test "#determine the identity pair" do
    argument = 10

    expected_from_function   = 10
    expected_from_derivative = 1

    setup = :identity

    %{function: function, derivative: derivative} = Activation.determine(setup)

    assert function.(argument)   == expected_from_function
    assert derivative.(argument) == expected_from_derivative
  end

  test "#determine the binary pair" do
    setup = :binary

    %{function: function, derivative: derivative} = Activation.determine(setup)

    argument = -1

    expected_from_function   = 0
    expected_from_derivative = 0

    assert function.(argument)   == expected_from_function
    assert derivative.(argument) == expected_from_derivative

    argument = 0

    expected_from_function   = 1
    expected_from_derivative = :undefined

    assert function.(argument)   == expected_from_function
    assert derivative.(argument) == expected_from_derivative

    argument = 1

    expected_from_function   = 1
    expected_from_derivative = 0

    assert function.(argument)   == expected_from_function
    assert derivative.(argument) == expected_from_derivative
  end

  test "#determine the logistic pair" do
    argument = 10

    expected_from_function   = 0.9999546021312976
    expected_from_derivative = 4.5395807735907655e-5

    setup = :logistic

    %{function: function, derivative: derivative} = Activation.determine(setup)

    assert function.(argument)   == expected_from_function
    assert derivative.(argument) == expected_from_derivative
  end

  test "#determine the tanh pair" do
    argument = 10

    expected_from_function   = 0.9999999958776927
    expected_from_derivative = 8.244614546626394e-9

    setup = :tanh

    %{function: function, derivative: derivative} = Activation.determine(setup)

    assert function.(argument)   == expected_from_function
    assert derivative.(argument) == expected_from_derivative
  end

  test "#determine the arctan pair" do
    argument = 10

    expected_from_function   = 1.4711276743037347
    expected_from_derivative = 0.009900990099009901

    setup = :arctan

    %{function: function, derivative: derivative} = Activation.determine(setup)

    assert function.(argument)   == expected_from_function
    assert derivative.(argument) == expected_from_derivative
  end

  test "#determine the softsign pair" do
    argument = 10

    expected_from_function   = 0.9090909090909091
    expected_from_derivative = 0.008264462809917356

    setup = :softsign

    %{function: function, derivative: derivative} = Activation.determine(setup)

    assert function.(argument)   == expected_from_function
    assert derivative.(argument) == expected_from_derivative
  end

  test "#determine the relu pair" do
    setup = :relu

    %{function: function, derivative: derivative} = Activation.determine(setup)

    argument = -2

    expected_from_function   = 0
    expected_from_derivative = 0

    assert function.(argument)   == expected_from_function
    assert derivative.(argument) == expected_from_derivative

    argument = 0

    expected_from_function   = 0
    expected_from_derivative = 1

    assert function.(argument)   == expected_from_function
    assert derivative.(argument) == expected_from_derivative

    argument = 2

    expected_from_function   = 2
    expected_from_derivative = 1

    assert function.(argument)   == expected_from_function
    assert derivative.(argument) == expected_from_derivative
  end
end
