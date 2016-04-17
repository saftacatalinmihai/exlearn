defmodule PropagatorTest do
  use ExUnit.Case, async: true

  alias BrainTonic.NeuralNetwork.{Builder, Forwarder, Propagator}

  @hidden_sizes [10]
  @input        [0, 1, 2, 3, 4]
  @input_size   5
  @output_size  1

  setup do
    parameters = %{
      layers: %{
        hidden: [
          %{
            activity: :identity,
            size: Enum.at(@hidden_sizes, 0)
          }
        ],
        input: %{
          size: @input_size
        },
        output: %{
          activity: :identity,
          size: @output_size
        }
      },
      learning_rate: 0.5,
      objective: :quadratic,
      random: %{
        distribution: :uniform,
        range:        {-1, 1}
      }
    }

    {:ok, parameters: parameters}
  end

  test "#back_propagate returns a map", %{parameters: parameters} do
    network    = Builder.initialize(parameters)
    activities = Forwarder.feed_forward_for_activity(@input, network)

    new_state = Propagator.back_propagate(network, activities, [123])

    assert new_state |> is_map
  end
end
