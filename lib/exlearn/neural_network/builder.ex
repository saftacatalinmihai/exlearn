defmodule ExLearn.NeuralNetwork.Builder do
  @moduledoc """
  Build functionality
  """

  alias ExLearn.{Activation, Distribution, Matrix, Objective}

  @doc """
  Initializez a neural network with the given setup
  """
  @spec initialize(map) :: map
  def initialize(setup) do
    %{
      layers: %{
        hidden: hidden_layers,
        input:  input_layer,
        output: output_layer
      },
      objective: objective_setup,
      random:    random
    } = setup

    layer_config = [input_layer] ++ hidden_layers ++ [output_layer]

    objective_function = Objective.determine(objective_setup)
    random_function    = Distribution.determine(random)

    layers = build_network(layer_config, random_function)

    %{network: %{layers: layers, objective: objective_function}, setup: setup}
  end

  defp build_network(configs, random_function) do
    build_network(configs, random_function, [])
  end

  defp build_network([_|[]], _, accumulator) do
    Enum.reverse(accumulator)
  end

  defp build_network([first, second|rest], random_function, accumulator) do
    %{size: rows} = first

    %{
      activity: function_setup,
      name:     name,
      size:     columns,
    } = second

    activity = Activation.determine(function_setup)
    biases   = Matrix.build(1, rows, random_function)
    weights  = Matrix.build(rows, columns, random_function)

    layer = %{
      activity: activity,
      biases:   biases,
      name:     name,
      weights:  weights,
    }

    build_network([second|rest], random_function, [layer|accumulator])
  end
end
