defmodule BrainTonic.NeuralNetwork.Propagator do
  @moduledoc """
  Propagates input trough a network
  """

  alias BrainTonic.Calculator

  @doc """
  Propagates input forward trough a network and return the result
  """
  @spec feed_forward([number], [[[number]]]) :: [number]
  def feed_forward(input, network) do
    %{
      activations: activations,
      biases:      biases,
      weights:     weights
    } = network

    full_network = {[[input]|weights], [], []}

    feed_forward(full_network, biases, activations)
  end

  @spec feed_forward([[[number]]], [[number]], [function]) :: [number]
  defp feed_forward({[network|[]], weighted_input, activity}, _, _) do
    [result] = network
    {result, weighted_input, activity}
  end

  defp feed_forward({[a, b | network], weighted_input, activity}, [c | biases], [d | activations]) do
    %{function: activation_function} = d
    input = Calculator.multiply(a, b)
      |> Calculator.add(c)

    result = input
      |> Calculator.apply(activation_function)

    new_activity       = result ++ activity
    new_weighted_input = input ++ weighted_input

    feed_forward({[result|network], new_weighted_input, new_activity}, biases, activations)
  end

  @doc """
  Performs backpropagation
  """
  @spec back_propagate(tuple, number, map) :: map
  def back_propagate(forwarded, cost_gradient, network) do
    {result, weighted_input, activity} = forwarded
    network
  end
end
