defmodule BrainTonic do
  @moduledoc """
  A neural network
  """

  @default_parameters %{
    hidden_layers_sizes: [1],
    hidden_layers_number: 1,
    input_size: 1,
    learning_rate: 0.5,
    output_layer_size: 1
  }

  @doc """
  Initalizez the neural network
  """
  @spec initialize(map) :: pid
  def initialize(parameters) do
    state = Map.merge(@default_parameters, parameters) |> initialize_state
    spawn fn -> network_loop(state) end
  end

  @doc """
  Trains the neural network
  """
  @spec train(any, pid) :: any
  def train(value, pid) do
    send pid, {:train, value}
  end

  @doc """
  Makes a prediction
  """
  @spec predict(any, pid) :: any
  def predict(input, pid) do
    send pid, {:predict, input}
  end

  @doc """
  Saves the neural network to disk
  """
  @spec save(pid) :: any
  def save(pid) do
    pid
  end

  @doc """
  Loads the neural network from disk
  """
  @spec load(any) :: pid
  def load(file) do
    file
  end

  @spec network_loop(map) :: no_return
  defp network_loop(state) do
    receive do
      {:train, input, caller} ->
        send caller, input
        network_loop(state)
      {:predict, input, caller} ->
        send caller, input
        network_loop(state)
    end
  end

  @spec initialize_state(map) :: map
  defp initialize_state(parameters) do
    layers = parameters[:hidden_layers_number] + 1
    hidden_sizes = parameters[:hidden_layers_sizes]
    output_size = parameters[:output_layer_size]
    column_sizes = List.insert_at(hidden_sizes, -1, output_size)
    weights = initialize_network(layers, column_sizes)
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
  defp initialize_tuple(accumulator, 0) do
    accumulator
  end

  defp initialize_tuple(accumulator, count) do
    # TODO: make this actually random
    value = :random.uniform
    new_acc = Tuple.append(accumulator, value)
    initialize_tuple(new_acc, count - 1)
  end
end
