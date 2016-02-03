defmodule BuilderTest do
  use ExUnit.Case, async: true

  alias BrainTonic.NeuralNetwork.Builder

  @range_min    -1
  @range_max    1
  @hidden_sizes [3]
  @input_size   2
  @output_size  1

  setup do
    parameters = %{
      random: %{
        distribution: :uniform,
        range:        {@range_min, @range_max}
      },
      sizes: %{
        hidden: @hidden_sizes,
        input:  @input_size,
        output: @output_size
      }
    }
    result = Builder.initialize(parameters)
    {:ok, result: result}
  end

  test "initialize return a map", %{result: result} do
    assert result |> is_map
    IO.inspect result
  end

  test "weights is a list of lists", %{result: result} do
    %{weights: weights} = result
    assert weights |> is_list
    Enum.map(weights, fn (element) ->
      assert element |> is_list
    end)
  end

  test "weights lists are the correct size", %{result: result} do
    %{weights: weights} = result
    last = length(@hidden_sizes)
    weights
    |> Enum.with_index
    |> Enum.map(fn
      {element, index} when index == last ->
        length(element) == @output_size
      {element, index} ->
        assert length(element) == Enum.at(@hidden_sizes, index)
    end)
  end

  test "biases is a list", %{result: result} do
    %{biases: biases} = result
    assert biases |> is_list
  end

  test "biases list is the correct size", %{result: result} do
    %{weights: biases} = result
    assert length(biases) == length(@hidden_sizes) + 1
  end

  test "weight and bias values are within range", %{result: result} do
    %{weights: weights} = result
    Enum.map(weights, fn (row) ->
      Enum.map(row, fn (element) ->
        assert element >= @range_min && element <= @range_max
      end)
    end)

    %{biases: biases} = result
    Enum.map(biases, fn (element) ->
      assert element >= @range_min && element <= @range_max
    end)
  end
end
