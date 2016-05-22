defmodule FeederTest do
  use ExUnit.Case, async: true

  alias BrainTonic.NeuralNetwork
  alias BrainTonic.NeuralNetwork.Feeder

  setup do
    network_parameters = %{
      layers: %{
        hidden: [
          %{
            activity: :identity,
            size:     1
          }
        ],
        input: %{
          size: 1
        },
        output: %{
          activity: :identity,
          size: 1
        }
      },
      objective: :quadratic,
      random: %{
        distribution: :uniform,
        range:        {-1, 1}
      }
    }

    network = NeuralNetwork.initialize(network_parameters)

    input = %{
      batch_size: 2,
      data: [
        {[0],  [0]},
        {[1],  [1]},
        {[2],  [2]},
        {[9],  [9]},
        {[10], [10]},
        {[42], [42]}
      ],
      data_size:      6,
      dropout:        0.5,
      epochs:         50,
      learning_rate:  0.5,
      regularization: :L2
    }

    {:ok, input: input, network: network}
  end

  test "#feed can be called", %{input: input, network: network} do
    Feeder.feed(network, input)
  end
end
