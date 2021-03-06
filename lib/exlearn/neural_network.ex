defmodule ExLearn.NeuralNetwork do
  @moduledoc """
  A neural network
  """

  alias ExLearn.NeuralNetwork.{Builder, Forwarder, Propagator}

  @doc """
  Makes a prediction
  """
  @spec ask(any, pid) :: any
  def ask(input, pid) do
    send pid, {:ask, input, self()}

    receive do
      response -> response
    end
  end

  @doc """
  Feeds input to the NeuralNetwork
  """
  @spec feed(list, map, pid) :: atom
  def feed(data, configuration, network) do
    %{epochs: epochs} = configuration

    feed_network(data, configuration, network, epochs)
  end

  @spec feed_network(list, map, pid, non_neg_integer) :: atom
  defp feed_network(_, _, _, 0), do: :ok
  defp feed_network(data, configuration, network, epochs)
      when is_integer(epochs) and epochs > 0 do

    %{batch_size: batch_size} = configuration
    batches = Enum.shuffle(data) |> Enum.chunk(batch_size)

    Enum.each(batches, fn(batch) ->
      train(batch, configuration, network)
    end)

    feed_network(data, configuration, network, epochs - 1)
  end

  @doc """
  Initalizez the neural network
  """
  @spec initialize(map) :: pid
  def initialize(parameters) do
    state = Builder.initialize(parameters)

    spawn fn -> network_loop(state) end
  end

  @doc """
  Makes a prediction and returs the cost
  """
  @spec test(any, map, pid) :: any
  def test(batch, configuration, pid) do
    send pid, {:test, batch, configuration, self()}

    receive do
      response -> response
    end
  end

  @doc """
  Trains the neural network
  """
  @spec train(list, map, pid) :: any
  def train(batch, configuration, pid) do
    send pid, {:train, batch, configuration, self()}

    receive do
      response -> response
    end
  end

  # @doc """
  # Returns a snapshot of the neural network
  # """
  # @spec inspect(pid) :: map
  # def inspect(pid) do
  #   send pid, :inspect
  # end

  # @doc """
  # Returns a snapshot of a certain part of the neural network
  # """
  # @spec inspect(atom, pid) :: map
  # def inspect(input, pid) do
  #   send pid, {:inspect, input}
  # end

  # @doc """
  # Saves the neural network to disk
  # """
  # @spec save(pid) :: any
  # def save(pid) do
  #   pid
  # end

  # @doc """
  # Loads the neural network from disk
  # """
  # @spec load(any) :: pid
  # def load(file) do
  #   file
  # end

  @spec network_loop(map) :: no_return
  defp network_loop(state) do
    receive do
      {:ask, input, caller} ->
        ask_network(input, state, caller)
        network_loop(state)
      {:test, batch, configuration, caller} ->
        result = test_network(batch, configuration, state)
        send caller, {:ok, result}
        network_loop(state)
      {:train, batch, configuration, caller} ->
        new_state = train_network(batch, configuration, state)
        send caller, :ok
        network_loop(new_state)
    end
  end

  defp ask_network(input, state, caller) do
    output = Forwarder.forward_for_output(input, state)

    send caller, {:ok, output}
  end

  defp test_network(batch, configuration, state) do
    outputs = Forwarder.forward_for_test(batch, state)

    %{network: %{objective: %{function: objective}}} = state
    %{data_size: data_size} = configuration

    targets = Enum.map(batch, fn ({_, target}) -> target end)

    costs = Enum.zip(targets, outputs)
      |> Enum.map(fn ({target, output}) -> objective.(target, output, data_size) end)

    {outputs, costs}
  end

  @spec train_network(list, map, map) :: map
  defp train_network(batch, configuration, state) do
    batch
    |> Forwarder.forward_for_activity(state)
    |> Propagator.back_propagate(configuration, state)
  end
end
