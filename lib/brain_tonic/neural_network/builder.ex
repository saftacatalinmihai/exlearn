defmodule BrainTonic.NeuralNetwork.Builder do
  @moduledoc """
  Build functionality
  """

  alias BrainTonic.{Activation, Distribution, Matrix, Objective, Vector}

  @doc """
  Initializez a neural network with the given setup
  """
  @spec initialize(map) :: map
  def initialize(setup) do
    %{
      layers:  %{
        hidden: hidden_layers,
        input:  input_layer,
        output: output_layer
      },
      objective: objective_setup,
      random:    random
    } = setup

    layers = [input_layer] ++ hidden_layers ++ [output_layer]

    objective_function = Objective.determine(objective_setup)
    random_function    = Distribution.determine(random)

    network = %{
      activity:  build_activations(layers),
      biases:    build_biases(layers, random_function),
      objective: objective_function,
      weights:   build_weights(layers, random_function)
    }

    %{network: network, setup: setup}
  end

  @spec build_activations([pos_integer,...]) :: list
  defp build_activations(layers) do
    build_activations(layers, [])
  end

  @spec build_activations([pos_integer,...], []) :: list

  defp build_activations([], total) do
    Enum.reverse(total)
  end

  defp build_activations([_|[]], total) do
    Enum.reverse(total)
  end

  defp build_activations([_, second | rest], total) do
    %{activity: function_setup} = second

    activation = Activation.determine(function_setup)

    build_activations([second|rest], [activation|total])
  end

  @spec build_biases([pos_integer,...], (() -> float)) :: list
  defp build_biases(layers, random_function) do
    build_biases(layers, [], random_function)
  end

  @spec build_biases([pos_integer,...], [], (() -> float)) :: list

  defp build_biases([], total, _) do
    Enum.reverse(total)
  end

  defp build_biases([_|[]], total, _) do
    Enum.reverse(total)
  end

  defp build_biases([_, second | rest], total, random_function) do
    %{size: size} = second
    biases = Vector.build(size, random_function)
    result = [biases|total]

    build_biases([second|rest], result, random_function)
  end

  @spec build_weights([pos_integer,...], (() -> float)) :: list
  defp build_weights(layers, random_function) do
    build_weights(layers, [], random_function)
  end

  @spec build_weights([pos_integer,...], [], (() -> float)) :: list

  defp build_weights([], total, _) do
    Enum.reverse(total)
  end

  defp build_weights([_|[]], total, _) do
    Enum.reverse(total)
  end

  defp build_weights([first, second | rest], total, random_function) do
    %{size: rows}    = first
    %{size: columns} = second
    weights = Matrix.build(rows, columns, random_function)
    result  = [weights|total]

    build_weights([second|rest], result, random_function)
  end
end
