defmodule ForwarderTest do
  use ExUnit.Case, async: true

  alias BrainTonic.NeuralNetwork.Forwarder

  # Netowrk mocked as following:
  # - input layer has 3 features
  # - there are 2 hidden layers
  # - h1 has 3 neurons
  # - h2 has 2 neurons
  # - output has one value
  #
  # I     H1    H2    O
  #   3x3   3x2   2x1
  # O     O     O     O
  # O     O     O
  # O     O
  setup do
    f = fn (x) -> x + 1 end
    d = fn (_) -> 1     end

    state = %{
      network: %{
        activity: [
          %{function: f, derivative: d},
          %{function: f, derivative: d},
          %{function: f, derivative: d}
        ],
        biases: [
          [1, 2, 3],
          [4, 5],
          [6]
        ],
        weights: [
          [
            [1, 2, 3],
            [4, 5, 6],
            [7, 8, 9]
          ],
          [
            [1, 2],
            [3, 4],
            [5, 6]
          ],
          [
            [1],
            [2]
          ]
        ]
      }
    }

    {:ok, setup: %{state: state, derivative: d}}
  end

  test "#feed_forward_for_output returns a list of numbers", %{setup: setup} do
    %{state: state} = setup

    input  = [1, 2, 3]
    output = Forwarder.feed_forward_for_output(input, state)

    assert output == [1395]
  end

  test "#feed_forward_for_activity returns a map", %{setup: setup} do
    %{state: state, derivative: d} = setup

    input    = [1, 2, 3]
    expected = %{
      activity: [
        %{
          derivative: d,
          input:      [[31, 38, 45]],
          output:     [[32, 39, 46]]
        },
        %{
          derivative: d,
          input:      [[383, 501]],
          output:     [[384, 502]]
        },
        %{
          derivative: d,
          input:      [[1394]],
          output:     [[1395]]
        }
      ],
      output: [1395]
    }

    result = Forwarder.feed_forward_for_activity(input, state)

    assert result == expected
  end
end
