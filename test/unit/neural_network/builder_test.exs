defmodule BuilderTest do
  use ExUnit.Case, async: true

  alias BrainTonic.NeuralNetwork.Builder

  setup do
    parameters = %{
      random: %{
        distribution: :uniform,
        range: {-2, 2}
      },
      sizes: %{
        hidden: [10, 15, 5],
        output: 3
      }
    }
    result = Builder.initialize(parameters)
    {:ok, result}
  end

  test "initialize return a map", result do
    assert result |> is_map
  end

  test "weights is a list of lists", result do
    %{weights: weights} = result
    assert weights |> is_list
    Enum.map(weights, fn (element) ->
      assert element |> is_list
    end)
  end

  test "weight values are within range", result do
    %{weights: weights} = result
    Enum.map(weights, fn (row) ->
      Enum.map(row, fn (element) ->
        assert element >= -2 && element <= 2
      end)
    end)
  end

  test "biases is a list", result do
    %{biases: biases} = result
    assert biases |> is_list
  end

  test "bias values are within range", result do
    %{biases: biases} = result
    Enum.map(biases, fn (element) ->
      assert element >= -2 && element <= 2
    end)
  end
end
