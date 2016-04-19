defmodule PropagatorTest do
  use ExUnit.Case, async: true

  alias BrainTonic.NeuralNetwork.Propagator

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
          [[6]]
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
            [1],
            [2]
          ]
        ]
      },
      setup: %{learning_rate: 2}
    }

    forwarded = %{
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
      output: [[1395]]
    }

    {:ok, setup: %{network: network, forwarded: forwarded, derivative: o}}
  end

  test "#back_propagate returns a map", %{setup: setup} do
    %{network: network, forwarded: forwarded, derivative: o} = setup

    data     = {[1, 2, 3], [[1400]]}
    expected = %{
      biases: [
        [[-49, -108, -167]],
        [[-6,  -15]],
        [[-4]]
      ],
      objective: %{derivative: o},
      weights: [
        [
          [-49,  -108, -167],
          [-96,  -215, -334],
          [-143, -322, -501]
        ],
        [
          [-319, -638],
          [-387, -776],
          [-455, -914]
        ],
        [
          [-3839],
          [-5018]
        ]
      ]
    }

    new_state = Propagator.back_propagate(network, forwarded, data)

    assert new_state == expected
  end
end
