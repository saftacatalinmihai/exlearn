defmodule FeederTest do
  use ExUnit.Case, async: true

  alias BrainTonic.NeuralNetwork.Feeder

  setup do
    parameters = %{
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

    {:ok, parameters: parameters}
  end

  test "#feed can be called", %{parameters: parameters} do
    network = nil

    Feeder.feed(network, parameters)
  end
end
