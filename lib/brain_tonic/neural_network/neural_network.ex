defmodule BrainTonic.NeuralNetwork do
  @moduledoc """
  A neural network
  """

  alias BrainTonic.NeuralNetwork.Builder

  @default_parameters %{
    random: %{
      distribution: :uniform,
      range:        {-1, 1}
    },
    sizes: %{
      hidden: [1],
      input:  1,
      output: 1
    },
    learning_rate: 0.5
  }

  @doc """
  Initalizez the neural network
  """
  @spec initialize(map) :: pid
  def initialize(parameters) do
    state = Map.merge(@default_parameters, parameters)
      |> Builder.initialize
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
  Returns a snapshot of the neural network
  """
  @spec inspect(pid) :: map
  def inspect(pid) do
    send pid, :inspect
  end

  @doc """
  Returns a snapshot of a certain part of the neural network
  """
  @spec inspect(atom, pid) :: map
  def inspect(input, pid) do
    send pid, {:inspect, input}
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
