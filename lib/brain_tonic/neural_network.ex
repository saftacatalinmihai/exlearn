defmodule BrainTonic.NeuralNetwork do
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
    state = Map.merge(@default_parameters, parameters)
      |> BrainTonic.Builder.initialize_neural_network
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
end
