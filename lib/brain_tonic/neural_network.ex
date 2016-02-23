defmodule BrainTonic.NeuralNetwork do
  @moduledoc """
  A neural network
  """

  alias BrainTonic.NeuralNetwork.{Builder, Propagator}

  @default_parameters %{
    layers: %{
      hidden: [
        %{
          activation: :identity,
          size: 1
        }
      ],
      input: %{
        size: 1
      },
      output: %{
        activation: :identity,
        size: 1
      }
    },
    learning_rate: 0.5,
    objective: :quadratic,
    random: %{
      distribution: :uniform,
      range:        {-1, 1}
    }
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
  def train(input, pid) do
    send pid, {:train, input, self()}
    receive do
      response -> response
    end
  end

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
      {:train, {input, output}, caller} ->
        %{network: network} = state
        %{objective: %{function: function, derivative: derivative}} = network

        forwarded = Propagator.feed_forward(input, network)

        {result, weighted_input, activity} = forwarded

        cost          = function.(output, result)
        cost_gradient = derivative.(output, result)

        new_state = Propagator.back_propagate(forwarded, cost_gradient, state)

        send caller, {:ok, {result, cost}}
        network_loop(new_state)
      {:ask, input, caller} ->
        %{network: network} = state
        {result, weighted_input, activity} = Propagator.feed_forward(input, network)
        send caller, {:ok, result}
        network_loop(state)
      {:test, {input, output}, caller} ->
        %{network: network} = state
        %{objective: %{function: function}} = network

        {result, weighted_input, activity} = Propagator.feed_forward(input, network)
        cost = function.(output, result)

        send caller, {:ok, {result, cost}}
        network_loop(state)
    end
  end
end
