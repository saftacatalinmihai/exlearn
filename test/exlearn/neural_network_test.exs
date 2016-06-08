defmodule NeuralNetworkTest do
  use ExUnit.Case, async: true

  alias ExLearn.NeuralNetwork

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

    config = %{
      dropout:        0.5,
      learning_rate:  0.005,
      regularization: :L2
    }

    data = [
      {[0], [0]},
      {[1], [1]},
      {[2], [2]},
      {[3], [3]},
      {[4], [4]},
      {[5], [5]}
    ]

    input = %{
      batch_size: 2,
      data:       data,
      data_size:  6,
      epochs:     5
    }

    {:ok, config: config, data: data, input: input, network: network}
  end

  test "#ask responds with a list of numbers", test_setup do
    %{data: data, network: network} = test_setup

    {:ok, result} = NeuralNetwork.ask(data, network)

    assert length(result) == length(data)
    Enum.each(result, fn (element) ->
      assert element |> is_list
      Enum.each(element, fn (number) ->
        assert number |> is_number
      end)
    end)
  end

  test "#configure is successfull", %{config: config, network: network} do
    expected = :ok

    result = NeuralNetwork.configure(config, network)

    assert result == expected
  end

  test "#feed can be called", test_setup do
    %{config: config, input: input, network: network} = test_setup

    NeuralNetwork.configure(config, network)
    NeuralNetwork.feed(network, input)
  end

  test "#initialize returns a running process", %{network: network} do
    assert network |> is_pid
    assert Process.alive?(network)
  end

  test "#test responds with a tuple", %{data: data, network: network} do
    output = NeuralNetwork.test(data, network)
    {:ok, {result, cost}} = output

    assert length(result) == length(data)
    Enum.each(result, fn (element) ->
      assert element |> is_list
    end)
    assert cost |> is_list
  end

  test "#train responds with a tuple", test_setup do
    %{config: config, data: data, network: network} = test_setup

    expected = :ok

    NeuralNetwork.configure(config, network)
    result = NeuralNetwork.train(data, network)

    assert result == expected
  end
end
