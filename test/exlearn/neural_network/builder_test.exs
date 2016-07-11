defmodule BuilderTest do
  use ExUnit.Case, async: true

  alias ExLearn.NeuralNetwork.Builder

  setup do
    parameters = %{
      layers: %{
        input:  %{size: 20},
        hidden: [
          %{
            activity: :identity,
            name:     "First Hidden",
            size:     3
          },
          %{
            activity: :identity,
            name:     "Second Hidden",
            size:     4
          },
          %{
            activity: :identity,
            name:     "Third Hidden",
            size:     5
          },
          %{
            activity: :identity,
            name:     "Fourth Hidden",
            size:     6
          }
        ],
        output: %{
          activity: :identity,
          name:     "Output",
          size:     5
        }
      },
      learning_rate: 0.5,
      objective:     :quadratic,
      random: %{
        distribution: :uniform,
        range:        {-1, 1}
      }
    }

    {:ok, parameters: parameters}
  end

  test "#initialize return a map", %{parameters: parameters} do
    result = Builder.initialize(parameters)

    assert result |> is_map
  end

  test "the number of layers is correct", %{parameters: parameters} do
    result = Builder.initialize(parameters)

    %{network: network} = result
    %{layers:  layers}  = network

    assert length(layers) == 5

    IO.inspect network
  end
end
