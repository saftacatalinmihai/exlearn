defmodule PropagatorTest do
  use ExUnit.Case, async: true

  alias BrainTonic.NeuralNetwork.{Builder, Propagator}

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
      objective: :quadratic,
      random: %{
        distribution: :uniform,
        range:        {-1, 1}
      }
    }

    result = Builder.initialize(parameters)

    {:ok, result: result}
  end

  test "#feed_forward returns a list of numbers", %{result: result} do
    %{network: network} = result

    {result, weighted_input, activity} = Propagator.feed_forward(@input, network)

    assert result |> is_list
    assert weighted_input |> is_list
    assert activity |> is_list
    assert length(result) == @output_size
    Enum.each(result, fn (element) ->
      assert element |> is_number
    end)
  end
end
