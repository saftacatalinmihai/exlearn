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
          size:     1
        }
      },
      objective: :quadratic,
      random: %{
        distribution: :uniform,
        range:        {-1, 1}
      }
    }

    network = NeuralNetwork.initialize(network_parameters)

    training_data = [
      {[0], [0]},
      {[1], [1]},
      {[2], [2]},
      {[3], [3]},
      {[4], [4]},
      {[5], [5]}
    ]

    ask_data = [[0], [1], [2], [3], [4], [5]]

    configuration = %{
      batch_size:     2,
      data_size:      6,
      dropout:        0.5,
      epochs:         5,
      learning_rate:  0.005,
      regularization: :L2
    }

    {:ok, setup: %{
      ask_data:      ask_data,
      configuration: configuration,
      network:       network,
      test_data:     training_data,
      training_data: training_data
    }}
  end

  test "#ask responds with a list of numbers", %{setup: setup} do
    %{ask_data: data, network: network} = setup

    {:ok, result} = NeuralNetwork.ask(data, network)

    assert length(result) == length(data)
    Enum.each(result, fn (element) ->
      assert element |> is_list
      Enum.each(element, fn (number) ->
        assert number |> is_number
      end)
    end)
  end

  test "#feed can be called", %{setup: setup} do
    %{
      configuration: configuration,
      network:       network,
      training_data: training_data
    } = setup

    NeuralNetwork.feed(training_data, configuration, network)
  end

  test "#initialize returns a running process", %{setup: setup} do
    %{network: network} = setup

    assert network |> is_pid
    assert Process.alive?(network)
  end

  test "#test responds with a tuple", %{setup: setup} do
    %{
      configuration: configuration,
      network:       network,
      test_data:     test_data
    } = setup

    output = NeuralNetwork.test(test_data, configuration, network)
    {:ok, {result, cost}} = output

    assert length(result) == length(test_data)
    Enum.each(result, fn (element) ->
      assert element |> is_list
    end)
    assert cost |> is_list
  end

  test "#train responds with a tuple", %{setup: setup} do
    %{
      configuration: configuration,
      network:       network,
      training_data: training_data,
    } = setup

    expected = :ok

    result = NeuralNetwork.train(training_data, configuration, network)

    assert expected == result
  end
end
