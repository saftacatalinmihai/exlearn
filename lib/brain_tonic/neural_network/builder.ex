defmodule BrainTonic.NeuralNetwork.Builder do
  @moduledoc """
  Build functionality
  """

  @spec initialize(map) :: map
  def initialize(parameters) do
    layers = parameters[:hidden_layers_number]
    hidden_sizes = parameters[:hidden_layers_sizes]
    output_size = parameters[:output_layer_size]
    column_sizes = hidden_sizes ++ [output_size]
    weights = initialize_network(layers + 1, column_sizes)
    biases = initialize_layer(layers)
    %{
      weights: weights,
      biases: biases,
      activations: []
    }
  end

  @spec initialize_network(pos_integer, [any(),...]) :: list
  defp initialize_network(rows, column_sizes) do
    initialize_layers([], rows, column_sizes)
  end

  @spec initialize_layers(list, pos_integer, list) :: list
  defp initialize_layers(layers, 0, _sizes) do
    layers
  end

  defp initialize_layers(layers, remaining, sizes) do
    [size | other_sizes] = sizes
    new_layer = initialize_layer(size)
    new_layers = layers ++ [new_layer]
    initialize_layers(new_layers, remaining - 1, other_sizes)
  end

  @spec initialize_layer(pos_integer) :: list
  defp initialize_layer(count) do
    initialize_list([], count - 1)
  end

  @spec initialize_list(list, pos_integer) :: list
  defp initialize_list(accumulator, -1) do
    accumulator
  end

  defp initialize_list(accumulator, count) do
    # TODO: make this more random
    << a :: 32, b :: 32, c :: 32 >> = :crypto.rand_bytes(12)
    :random.seed(a,b,c)
    value = :random.uniform
    new_acc = accumulator ++ [value]
    initialize_list(new_acc, count - 1)
  end
end
