defmodule ActivationTest do
  use ExUnit.Case, async: true

  alias ExLearn.Activation

  test "#apply_derivative for arity 1" do
    activity = %{arity: 1, derivative: &(&1 + 1)}
    data     = [[1, 2, 3]]
    expected = [[2, 3, 4]]

    result = Activation.apply_derivative(data, activity)

    assert expected == result
  end

  test "#apply_derivative for arity 2" do
    activity = %{arity: 2, derivative: &Enum.sum/1}
    data     = [1, 2, 3]
    expected = 6

    result = Activation.apply_derivative(data, activity)

    assert expected == result
  end

  test "#apply_function for arity 1" do
    activity = %{arity: 1, function: &(&1 + 1)}
    data     = [[1, 2, 3]]
    expected = [[2, 3, 4]]

    result = Activation.apply_function(data, activity)

    assert expected == result
  end

  test "#apply_function for arity 2" do
    activity = %{arity: 2, function: &(&1 + Enum.sum(&2))}
    data     = [[1, 2, 3]]
    expected = [[7, 8, 9]]

    result = Activation.apply_function(data, activity)

    assert expected == result
  end

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

  test "#determine the softplus pair" do
    argument = 10

    expected_from_function   = 10.000045398899218
    expected_from_derivative = 0.9999546021312976

    setup = :softplus

    %{function: function, derivative: derivative} = Activation.determine(setup)

    assert function.(argument)   == expected_from_function
    assert derivative.(argument) == expected_from_derivative
  end

  test "#determine the bent_identity pair" do
    argument = 10

    expected_from_function   = 14.524937810560445
    expected_from_derivative = 1.4975185951049945

    setup = :bent_identity

    %{function: function, derivative: derivative} = Activation.determine(setup)

    assert function.(argument)   == expected_from_function
    assert derivative.(argument) == expected_from_derivative
  end

  test "#determine the sinusoid pair" do
    argument = 0

    expected_from_function   = 0
    expected_from_derivative = 1

    setup = :sinusoid

    %{function: function, derivative: derivative} = Activation.determine(setup)

    assert function.(argument)   == expected_from_function
    assert derivative.(argument) == expected_from_derivative
  end

  test "#determine the softmax pair" do
    all      = [-1.5, 0.2, 0.3, 3]
    argument = 3

    expected_from_function   = 0.8778671136285249
    expected_from_derivative = [[1.5, -0.2, -0.29999999999999993, -3.0]]

    setup = :softmax

    %{function: function, derivative: derivative} = Activation.determine(setup)

    assert function.(argument, all) == expected_from_function
    assert derivative.([all])       == expected_from_derivative
  end

  test "#determine the softmax pair with no overflow" do
    all      = [-1.5, 880, 0.3, 3]
    argument = 880

    expected_from_function   = 1.0
    expected_from_derivative = [[1321.2, -775104.0, -264.24, -2642.4]]

    setup = :softmax

    %{function: function, derivative: derivative} = Activation.determine(setup)

    assert function.(argument, all) == expected_from_function
    assert derivative.([all])       == expected_from_derivative
  end

  test "#determine the sinc pair" do
    setup = :sinc

    %{function: function, derivative: derivative} = Activation.determine(setup)

    argument = 0

    expected_from_function   = 1
    expected_from_derivative = 0

    assert function.(argument)   == expected_from_function
    assert derivative.(argument) == expected_from_derivative

    argument = 1

    expected_from_function   = 0.8414709848078965
    expected_from_derivative = -0.30116867893975674

    assert function.(argument)   == expected_from_function
    assert derivative.(argument) == expected_from_derivative
  end

  test "#determine the gaussian pair" do
    argument = 10

    expected_from_function   = 3.720075976020836e-44
    expected_from_derivative = -7.440151952041672e-43

    setup = :gaussian

    %{function: function, derivative: derivative} = Activation.determine(setup)

    assert function.(argument)   == expected_from_function
    assert derivative.(argument) == expected_from_derivative
  end

  test "#determine the prelu pair" do
    setup = {:prelu, alpha: 10}

    %{function: function, derivative: derivative} = Activation.determine(setup)

    argument = -2

    expected_from_function   = -20
    expected_from_derivative = 10

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

  test "#determine the elu pair" do
    setup = {:elu, alpha: 10}

    %{function: function, derivative: derivative} = Activation.determine(setup)

    argument = -2

    expected_from_function   = -8.646647167633873
    expected_from_derivative = 1.3533528323661272

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
