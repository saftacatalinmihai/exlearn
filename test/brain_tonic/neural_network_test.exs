defmodule NeuralNetworkTest do
  use ExUnit.Case, async: true

  alias BrainTonic.NeuralNetwork

  @hidden_sizes [10]
  @input        [0, 1, 2, 3, 4]
  @input_size   5
  @output_size  1

  setup do
    parameters = %{
      layers: %{
        hidden: [
          %{
            activation: :identity,
            size: Enum.at(@hidden_sizes, 0)
          }
        ],
        input: %{
          size: @input_size
        },
        output: %{
          activation: :identity,
          size: @output_size
        }
      },
      learning_rate: 0.5,
      random: %{
        distribution: :uniform,
        range:        {-1, 1}
      }
    }

    result = NeuralNetwork.initialize(parameters)

    {:ok, result: result}
  end

  test "#initialize returns a running process", %{result: network} do
    assert network |> is_pid
    assert Process.alive?(network)
  end

  test "#ask respondes with a list of numbers", %{result: network} do
    {:ok, result} = NeuralNetwork.ask(@input, network)

    assert length(result) == @output_size
    Enum.each(result, fn (element) ->
      assert element |> is_number
    end)
  end
end
