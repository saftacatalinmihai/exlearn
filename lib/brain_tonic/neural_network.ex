defmodule BrainTonic.NeuralNetwork do
  @moduledoc """
  A neural network
  """

  alias BrainTonic.NeuralNetwork.{Builder, Forwarder, Propagator}

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
  Configures the network hyper parameters
  """
  @spec configure(map, pid) :: any
  def configure(parameters, pid) do
    send pid, {:configure, parameters, self()}

    receive do
      response -> response
    end
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
  @spec test(any, pid) :: any
  def test(input, pid) do
    send pid, {:test, input, self()}

    receive do
      response -> response
    end
  end

  @doc """
  Trains the neural network
  """
  @spec train(any, pid) :: any
  def train(batch, pid) do
    send pid, {:train, batch, self()}

    receive do
      response -> response
    end
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
      {:ask, input, caller} ->
        ask_network(input, state, caller)
        network_loop(state)
      {:configure, parameters, caller} ->
        new_state = configure_network(parameters, state)
        send caller, :ok
        network_loop(new_state)
      {:test, input, caller} ->
        test_network(input, state, caller)
        network_loop(state)
      {:train, batch, caller} ->
        new_state = train_network(batch, state, caller)
        send caller, :ok
        network_loop(new_state)
    end
  end

  defp ask_network(input, state, caller) do
    [output] = Forwarder.forward_for_output(input, state)

    send caller, {:ok, output}
  end

  @spec configure_network(map, map) :: map
  defp configure_network(parameters, state) do
    put_in(state, [:parameters], parameters)
  end

  defp test_network({input, [target]}, state, caller) do
    [output] = Forwarder.forward_for_output(input, state)

    %{network: %{objective: %{function: objective}}} = state

    cost = objective.(target, output)

    send caller, {:ok, {output, cost}}
  end

  @spec train_network([{[], []}], %{}, pid) :: map
  defp train_network(batch, state, caller) do
    Forwarder.forward_for_activity(batch, state)
    |> Propagator.back_propagate(batch, state)
  end
end
