defmodule ForwarderTest do
  use ExUnit.Case, async: true

  alias ExLearn.NeuralNetwork.Forwarder

  # Netowrk mocked as following:
  # - input layer has 3 features
  # - there are 2 hidden layers
  # - h1 has 3 neurons
  # - h2 has 2 neurons
  # - output has 2 values
  #
  # I     H1    H2    O
  #   3x3   3x2   2x2
  # O     O     O     O
  # O     O     O     O
  # O     O
  setup do
    f = fn (x) -> x + 1 end
    d = fn (_) -> 1     end

    state = %{
      network: %{
        layers: [
          %{
            activity: %{arity: 1, function: f, derivative: d},
            biases:   [[1, 2, 3]],
            weights:  [[1, 2, 3], [4, 5, 6], [7, 8, 9]]
          },
          %{
            activity: %{arity: 1, function: f, derivative: d},
            biases:   [[4, 5]],
            weights:  [[1, 2], [3, 4], [5, 6]]
          },
          %{
            activity: %{arity: 1, function: f, derivative: d},
            biases:   [[6, 7]],
            weights:  [[1, 2], [3, 4]]
          },
        ]
      }
    }

    {:ok, setup: %{
      derivative: d,
      function:   f,
      state:      state,
    }}
  end

  test "#forward_for_output returns the outputs", %{setup: setup} do
    %{state: state} = setup

    inputs   = [[1, 2, 3], [2, 3, 4]]
    expected = [[1897, 2784], [2620, 3846]]

    output = Forwarder.forward_for_output(inputs, state)

    assert expected == output
  end

  test "#forward_for_activity returns the activities", %{setup: setup} do
    %{
      derivative: derivative,
      function:   function,
      state:      state
    } = setup

    input = [
      {[1, 2, 3], [1900, 2800]},
      {[2, 3, 4], [2600, 3800]}
    ]

    first_activity = %{
      activity: [
        %{
          arity:      1,
          function:   function,
          derivative: derivative,
          input:      [[31, 38, 45]],
          output:     [[32, 39, 46]]
        },
        %{
          arity:      1,
          function:   function,
          derivative: derivative,
          input:      [[383, 501]],
          output:     [[384, 502]]
        },
        %{
          arity:      1,
          function:   function,
          derivative: derivative,
          input:      [[1896, 2783]],
          output:     [[1897, 2784]]
        }
      ],
      expected: [1900, 2800],
      input:    [1, 2, 3],
      output:   [1897, 2784]
    }

    second_activity = %{
      activity: [
        %{
          arity:      1,
          function:   function,
          derivative: derivative,
          input:      [[43, 53, 63]],
          output:     [[44, 54, 64]]
        },
        %{
          arity:      1,
          function:   function,
          derivative: derivative,
          input:      [[530, 693]],
          output:     [[531, 694]]
        },
        %{
          arity:      1,
          function:   function,
          derivative: derivative,
          input:      [[2619, 3845]],
          output:     [[2620, 3846]]
        }
      ],
      expected: [2600, 3800],
      input:    [2, 3, 4],
      output:   [2620, 3846]
    }

    expected = [first_activity, second_activity]

    output = Forwarder.forward_for_activity(input, state)

    assert expected == output
  end
end
