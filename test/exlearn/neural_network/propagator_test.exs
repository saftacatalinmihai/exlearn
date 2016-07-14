defmodule PropagatorTest do
  use ExUnit.Case, async: true

  alias ExLearn.NeuralNetwork.Propagator

  setup do
    derivative = fn(_)    -> 1 end
    objective  = fn(a, b) ->
      Stream.zip(b, a) |> Enum.map(fn({x, y}) -> x - y end)
    end

    configuration = %{learning_rate: 2}

    network_state = %{
      network: %{
        layers: [
          %{
            activity: %{derivative: derivative},
            biases:   [[1, 2, 3]],
            weights:  [[1, 2, 3], [4, 5, 6], [7, 8, 9]]
          },
          %{
            activity: %{derivative: derivative},
            biases:   [[4, 5]],
            weights:  [[1, 2], [3, 4], [5, 6]]
          },
          %{
            activity: %{derivative: derivative},
            biases:   [[6, 7]],
            weights:  [[1, 2], [3, 4]]
          },
        ],
        objective: %{derivative: objective}
      }
    }

    first_forward_state = %{
      activity: [
        %{
          derivative: derivative,
          input:      [[31, 38, 45]],
          output:     [[32, 39, 46]]
        },
        %{
          derivative: derivative,
          input:      [[383, 501]],
          output:     [[384, 502]]
        },
        %{
          derivative: derivative,
          input:      [[1896, 2783]],
          output:     [[1897, 2784]]
        }
      ],
      expected: [1900, 2800],
      input:    [1, 2, 3],
      output:   [1897, 2784]
    }

    second_forward_state = %{
      activity: [
        %{
          derivative: derivative,
          input:      [[43, 53, 63]],
          output:     [[44, 54, 64]]
        },
        %{
          derivative: derivative,
          input:      [[530, 693]],
          output:     [[531, 694]]
        },
        %{
          derivative: derivative,
          input:      [[2619, 3845]],
          output:     [[2620, 3846]]
        }
      ],
      expected: [2600, 3800],
      input:    [2, 3, 4],
      output:   [2620, 3846]
    }

    forward_batch = [first_forward_state, second_forward_state]

    {:ok, setup: %{
      configuration: configuration,
      derivative:    derivative,
      forward_batch: forward_batch,
      network_state: network_state,
      objective:     objective
    }}
  end

  test "#back_propagate returns a map", %{setup: setup} do
    %{
      configuration: configuration,
      derivative:    derivative,
      forward_batch: forward_batch,
      network_state: network_state,
      objective:     objective
    } = setup

    expected = %{
      network: %{
        layers: [
          %{
            activity: %{derivative: derivative},
            biases:   [[-837, -1828, -2819]],
            weights:  [
              [-2037, -4452, -6867 ],
              [-2872, -6279, -9686 ],
              [-3707, -8106, -12505]
            ]
          },
          %{
            activity: %{derivative: derivative},
            biases:   [[-150, -337]],
            weights:  [
              [-7615,  -16798],
              [-9363,  -20654],
              [-11111, -24510]
            ]
          },
          %{
            activity: %{derivative: derivative},
            biases:   [[-28, -53]],
            weights:  [
              [-18935, -36562],
              [-24745, -47780]
            ]
          }
        ],
        objective: %{derivative: objective}
      }
    }

    result = Propagator.back_propagate(
      forward_batch,
      configuration,
      network_state
    )

    assert expected == result
  end
end
