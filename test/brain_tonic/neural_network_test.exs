defmodule NeuralNetworkTest do
  use ExUnit.Case, async: true

  alias BrainTonic.NeuralNetwork

  @expected_output [1]
  @hidden_sizes    [10]
  @input           [0, 1, 2, 3, 4]
  @input_size      5
  @output_size     1

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
      objective:  :quadratic,
      random: %{
        distribution: :uniform,
        range:        {-1, 1}
      }
    }

    network = NeuralNetwork.initialize(parameters)
    NeuralNetwork.configure(%{learning_rate: 0.5}, network)

    {:ok, network: network}
  end

  test "#ask responds with a list of numbers", %{network: network} do
    {:ok, result} = NeuralNetwork.ask([@input], network)

    assert length(result) == @output_size
    Enum.each(result, fn (element) ->
      assert element |> is_number
    end)
  end

  test "#configure is successfull", %{network: network} do
    parameters = %{learning_rate: 0.5}
    expected   = :ok

    result = NeuralNetwork.configure(parameters, network)

    assert result == expected
  end

  test "#initialize returns a running process", %{network: network} do
    assert network |> is_pid
    assert Process.alive?(network)
  end

  test "#test responds with a tuple", %{network: network} do
    input  = [{@input, @expected_output}]

    output = NeuralNetwork.test(input, network)
    {:ok, {result, cost}} = output

    assert length(result) == @output_size
    Enum.each(result, fn (element) ->
      assert element |> is_number
    end)
    assert cost |> is_number
  end

  test "#train responds with a tuple", %{network: network} do
    input    = [{@input, @expected_output}]
    expected = :ok

    result = NeuralNetwork.train(input, network)

    assert result == expected
  end
end
