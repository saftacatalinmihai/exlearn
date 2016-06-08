defmodule PropagatorTest do
  use ExUnit.Case, async: true

  alias ExLearn.NeuralNetwork.Propagator

  setup do
    d = fn (_)    -> 1 end
    o = fn (a, b) ->
      Stream.zip(b, a) |> Enum.map(fn({x, y}) -> x - y end)
    end

    network = %{
      network: %{
        biases: [
          [[1, 2, 3]],
          [[4, 5]],
          [[6, 7]]
        ],
        objective: %{derivative: o},
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
            [1, 2],
            [3, 4]
          ]
        ]
      },
      parameters: %{learning_rate: 2}
    }

    first_activity = %{
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
          input:      [[1896, 2783]],
          output:     [[1897, 2784]]
        }
      ],
      output: [1897, 2784]
    }

    second_activity = %{
      activity: [
        %{
          derivative: d,
          input:      [[43, 53, 63]],
          output:     [[44, 54, 64]]
        },
        %{
          derivative: d,
          input:      [[530, 693]],
          output:     [[531, 694]]
        },
        %{
          derivative: d,
          input:      [[2619, 3845]],
          output:     [[2620, 3846]]
        }
      ],
      output: [2620, 3846]
    }

    forwarded = [first_activity, second_activity]

    {:ok, setup: %{network: network, forwarded: forwarded, derivative: o}}
  end

  test "#back_propagate returns a map", %{setup: setup} do
    %{network: network, forwarded: forwarded, derivative: o} = setup

    data = [
      {[1, 2, 3], [1900, 2800]},
      {[2, 3, 4], [2600, 3800]}
    ]

    expected = %{
      network: %{
        biases: [
          [[-837, -1828, -2819]],
          [[-150, -337]],
          [[-28,  -53]]
        ],
        objective: %{derivative: o},
        weights: [
          [
            [-2037, -4452, -6867 ],
            [-2872, -6279, -9686 ],
            [-3707, -8106, -12505]
          ],
          [
            [-7615,  -16798],
            [-9363,  -20654],
            [-11111, -24510]
          ],
          [
            [-18935, -36562],
            [-24745, -47780]
          ]
        ]
      },
      parameters: %{learning_rate: 2}
    }

    new_state = Propagator.back_propagate(forwarded, data, network)

    assert new_state == expected
  end
end
