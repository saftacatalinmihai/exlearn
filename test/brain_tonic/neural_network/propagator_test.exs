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
          [1, 2, 3],
          [4, 5],
          [6]
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
      }
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

    {:ok, setup: %{network: network, forwarded: forwarded}}
  end

  test "#back_propagate returns a map", %{setup: setup} do
    %{network: network, forwarded: forwarded} = setup

    target    = [[1400]]
    new_state = Propagator.back_propagate(network, forwarded, target)

    # assert new_state |> is_map
  end
end
