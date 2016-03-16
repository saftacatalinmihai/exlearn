defmodule BrainTonic.NeuralNetwork.Propagator do
  @moduledoc """
  Propagates input trough a network
  """

  alias BrainTonic.Calculator

  @doc """
  Propagates input forward trough a network and return the result
  """
  @spec feed_forward([number], map) :: map
  def feed_forward(input, state) do
    %{network: network} = state
    %{weights: weights} = network

    full_network = put_in(network.weights, [[input]|weights])

    inverse_activity        = calculate_activity(full_network, [])
    [%{output: [output]} | _] = inverse_activity
    new_activity            = Enum.reverse(inverse_activity)

    state
      |> put_in([:network, :activity], new_activity)
      |> put_in([:network, :output], output)
  end

  @spec calculate_activity(map, list) :: map
  defp calculate_activity(network, activity) do
    case network do
      %{weights: [_|[]]} ->
        activity
      %{weights: [w1, w2 | ws], biases: [b | bs], activity: [a | as]} ->
        %{function: f} = a

        input  = Calculator.multiply(w1, w2) |> Calculator.add(b)
        output = input |> Calculator.apply(f)
        new_a  = %{function: f, input: input, output: output}

        new_network = %{weights: [output | ws], biases: bs, activity: as}

        calculate_activity(new_network, [new_a | activity])
    end
  end

  @doc """
  Performs backpropagation
  """
  @spec back_propagate(tuple, number, map) :: map
  def back_propagate(forwarded, cost_gradient, network) do
    {result, weighted_input, activity} = forwarded

    back_propagater(forwarded, cost_gradient, network)
  end

  def back_propagater(forwarded, cost_gradient, network) do
    {result, weighted_input, activity} = forwarded
    %{
      activations: activations,
      biases:      biases,
      weights:     weights
    } = network

    deltas = calculate_detlas(weights, cost_gradient, weighted_input, activations, [])
    bias_change = deltas
    weight_chage = calculate_weight_change(activity, deltas, [])

    new_weights = calculate_new_weights(weights, weight_chage, network)
    new_biases = calculate_new_biases(biases, bias_change, network)

    create_new_network(network, new_weights, new_biases)
  end

  def calculate_new_weights(weights, weight_chage, network) do
    # TODO
    weights
  end

  def calculate_new_biases(biases, bias_change, network) do
    # TODO
    biases
  end

  def create_new_network(network, new_weights, new_biases) do
    # TODO
    network
  end

  def calculate_detlas([], cost_gradient, [weighted_input], [activation], totals) do
    %{derivative: derivative} = activation

    delta = Calculator.dot_product(cost_gradient, derivative.(weighted_input))

    Enum.reverse([delta|totals])
  end

  def calculate_detlas([weight|weights], cost_gradient, [weighted_input|weighted_inputs], [activation|activations], [delta|totals]) do
    %{derivative: derivative} = activation

    delta = Calculator.dot_product(Calculator.dot_product(Calculator.trasnspose(weight), delta), derivative.(weighted_input))

    calculate_detlas(weights, cost_gradient, weighted_inputs, activations, totals)
  end

  def calculate_weight_change([], [], totals) do
    Enum.reverse(totals)
  end

  def calculate_weight_change([activity|activities], [delta, deltas], total) do
    result = Calculator.dot_product(activity, delta)

    calculate_weight_change(activities, deltas, [result|total])
  end
end
