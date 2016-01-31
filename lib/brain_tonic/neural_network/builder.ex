defmodule BrainTonic.NeuralNetwork.Builder do
  @moduledoc """
  Build functionality
  """

  @spec initialize_neural_network(map) :: map
  def initialize_neural_network(parameters) do
    layers = parameters[:hidden_layers_number]
    hidden_sizes = parameters[:hidden_layers_sizes]
    output_size = parameters[:output_layer_size]
    column_sizes = List.insert_at(hidden_sizes, -1, output_size)
    weights = initialize_network(layers + 1, column_sizes)
    biases = initialize_layer(layers)
    %{
      weights: weights,
      biases: biases,
      activations: {}
    }
  end

  @spec initialize_network(pos_integer, [any(),...]) :: tuple
  defp initialize_network(rows, column_sizes) do
    initialize_layers({}, rows, column_sizes)
  end

  @spec initialize_layers(tuple, pos_integer, list) :: tuple
  defp initialize_layers(layers, 0, _sizes) do
    layers
  end

  defp initialize_layers(layers, remaining, sizes) do
    [size | other_sizes] = sizes
    new_layer = initialize_layer(size)
    new_layers = Tuple.append(layers, new_layer)
    initialize_layers(new_layers, remaining - 1, other_sizes)
  end

  @spec initialize_layer(pos_integer) :: tuple
  defp initialize_layer(count) do
    initialize_tuple({}, count - 1)
  end

  @spec initialize_tuple(tuple, pos_integer) :: tuple
  defp initialize_tuple(accumulator, -1) do
    accumulator
  end

  defp initialize_tuple(accumulator, count) do
    # TODO: make this more random
    << a :: 32, b :: 32, c :: 32 >> = :crypto.rand_bytes(12)
    :random.seed(a,b,c)
    value = :random.uniform
    new_acc = Tuple.append(accumulator, value)
    initialize_tuple(new_acc, count - 1)
  end
end
