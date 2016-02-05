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
            activation: :identity,
            size: Enum.at(@hidden_sizes, 0)
          },
          %{
            activation: :identity,
            size: Enum.at(@hidden_sizes, 1)
          },
          %{
            activation: :identity,
            size: Enum.at(@hidden_sizes, 2)
          },
          %{
            activation: :identity,
            size: Enum.at(@hidden_sizes, 3)
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
        range:        {@range_min, @range_max}
      }
    }

    result = Builder.initialize(parameters)

    {:ok, result: result}
  end

  test "initialize return a map", %{result: result} do
    assert result |> is_map
  end

  test "weights is a list of matrixes", %{result: result} do
    %{weights: weights} = result

    assert weights |> is_list
    Enum.each(weights, fn (matrix) ->
      assert matrix |> is_list
      Enum.each(matrix, fn (list) ->
        assert list |> is_list
      end)
    end)
  end

  test "weights lists are the correct size", %{result: result} do
    %{weights: weights} = result

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

  test "biases is a list of lists", %{result: result} do
    %{biases: biases} = result

    assert biases |> is_list
    Enum.each(biases, fn (list) ->
      assert list |> is_list
    end)
  end

  test "biases lists are the correct size", %{result: result} do
    %{biases: biases} = result

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

  test "weight and bias values are within range", %{result: result} do
    %{weights: weights, biases: biases} = result

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
