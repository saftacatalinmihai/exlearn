defmodule BrainTonic do
  @moduledoc """
  A neural network
  """

  @default_options %{
    input_size: 1,
    number_of_hidden_layers: 1,
    hidden_layer_sizes: [1],
    output_layer_size: 1,
    learning_rate: 0.5
  }

  @doc """
  Initalizez the neural network
  """
  @spec initialize(map) :: pid
  def initialize(options) do
    settings = Map.merge(@default_options, options)
    spawn fn -> settings end
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
end
