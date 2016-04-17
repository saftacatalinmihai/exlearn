defmodule BuilderTest do
  use ExUnit.Case, async: true

  alias BrainTonic.NeuralNetwork.Builder

  @range_min    -1
  @range_max    1
  @hidden_sizes [30, 40, 50, 60]
  @input_size   20
  @output_size  5

  setup do
    parameters = %{
      layers: %{
        hidden: [
          %{
            activity: :identity,
            size: Enum.at(@hidden_sizes, 0)
          },
          %{
            activity: :identity,
            size: Enum.at(@hidden_sizes, 1)
          },
          %{
            activity: :identity,
            size: Enum.at(@hidden_sizes, 2)
          },
          %{
            activity: :identity,
            size: Enum.at(@hidden_sizes, 3)
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
        range:        {@range_min, @range_max}
      }
    }

    {:ok, parameters: parameters}
  end

  test "#initialize return a map", %{parameters: parameters} do
    result = Builder.initialize(parameters)

    assert result |> is_map
  end

  test "weights are the correct size", %{parameters: parameters} do
    result = Builder.initialize(parameters)

    %{network: network} = result
    %{weights: weights} = network

    last = length(@hidden_sizes)

    assert length(weights) == length(@hidden_sizes) + 1

    Enum.with_index(weights)
    |> Enum.each(fn
      {list, index} when index == 0 ->
        assert length(list) == @input_size
        Enum.each(list, fn (element) ->
          assert length(element) == Enum.at(@hidden_sizes, index)
        end)
      {list, index} when index == last ->
        assert length(list) == Enum.at(@hidden_sizes, index - 1)
        Enum.each(list, fn (element) ->
          assert length(element) == @output_size
        end)
      {list, index} ->
        assert length(list) == Enum.at(@hidden_sizes, index - 1)
        Enum.each(list, fn (element) ->
          assert length(element) == Enum.at(@hidden_sizes, index)
        end)
    end)
  end

  test "biases are the correct size", %{parameters: parameters} do
    result = Builder.initialize(parameters)

    %{network: network} = result
    %{biases: biases}   = network

    last = length(biases)

    assert length(biases) == length(@hidden_sizes) + 1

    Enum.with_index(biases)
    |> Enum.each(fn
      {element, index} when index == last - 1 ->
        assert length(element) == @output_size
      {element, index} ->
        assert length(element) == Enum.at(@hidden_sizes, index)
    end)
  end

  test "weight and bias values are within range", %{parameters: parameters} do
    result = Builder.initialize(parameters)

    %{network: network} = result
    %{weights: weights, biases: biases} = network

    Enum.each(weights, fn (matrix) ->
      Enum.each(matrix, fn (row) ->
        Enum.each(row, fn (element) ->
          assert element >= @range_min && element <= @range_max
        end)
      end)
    end)
    Enum.each(biases, fn (lists) ->
      Enum.each(lists, fn (element) ->
        assert element >= @range_min && element <= @range_max
      end)
    end)
  end
end
