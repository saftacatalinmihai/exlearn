defmodule NeuralNetworkTest do
  use ExUnit.Case, async: true

  alias ExLearn.NeuralNetwork

  setup do
    network_parameters = %{
      layers: %{
        input:  %{size: 1},
        hidden: [
          %{
            activity: :identity,
            name:     "First Hidden",
            size:     1
          }
        ],
        output: %{
          activity: :identity,
          name:     "Output",
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

    training_data = [
      {[0], [0]},
      {[1], [1]},
      {[2], [2]},
      {[3], [3]},
      {[4], [4]},
      {[5], [5]}
    ]

    ask_data = [[0], [1], [2], [3], [4], [5]]

    input = %{
      batch_size: 2,
      data:       training_data,
      data_size:  6,
      epochs:     5
    }

    {
      :ok,
      ask_data:   ask_data,
      config:     config,
      input:      input,
      network:    network,
      test_data:  training_data,
      train_data: training_data
    }
  end

  test "#ask responds with a list of numbers", test_setup do
    %{ask_data: data, network: network} = test_setup

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
    NeuralNetwork.feed(input, network)
  end

  test "#initialize returns a running process", %{network: network} do
    assert network |> is_pid
    assert Process.alive?(network)
  end

  test "#test responds with a tuple", %{test_data: data, network: network} do
    output = NeuralNetwork.test(data, network)
    {:ok, {result, cost}} = output

    assert length(result) == length(data)
    Enum.each(result, fn (element) ->
      assert element |> is_list
    end)
    assert cost |> is_list
  end

  test "#train responds with a tuple", test_setup do
    %{config: config, train_data: data, network: network} = test_setup

    expected = :ok

    NeuralNetwork.configure(config, network)
    result = NeuralNetwork.train(data, network)

    assert result == expected
  end
end
