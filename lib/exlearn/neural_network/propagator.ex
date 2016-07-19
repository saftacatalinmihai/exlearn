defmodule ExLearn.NeuralNetwork.Propagator do
  @moduledoc """
  Backpropagates the error trough a network
  """

  alias ExLearn.{Activation, Matrix}

  @doc """
  Performs backpropagation
  """
  @spec back_propagate([%{}], map, %{}) :: map
  def back_propagate(forward_batch, configuration, state) do
    %{network: %{layers: network_layers}} = state

    Enum.reduce(forward_batch, state, fn (forward_state, new_state) ->
      deltas = calculate_deltas(forward_state, network_layers, state)

      %{activity: activity, input: input} = forward_state

      full_activity  = [%{output: [input]}|activity]
      bias_change    = deltas
      weight_change  = calculate_weight_change(full_activity, deltas, [])

      apply_changes(bias_change, weight_change, configuration, new_state)
    end)
  end

  defp calculate_deltas(forward_state, network_layers, state) do
    %{
      activity: activity_layers,
      expected: expected,
      output:   output
    } = forward_state

    reversed_activity_layers = Enum.reverse(activity_layers)
    reversed_network_layers  = Enum.reverse(network_layers)

    [last_activity_layer|rest] = reversed_activity_layers

    %{network: %{objective: %{derivative: objective}}} = state
    cost_gradient = [objective.(expected, output)]

    starting_delta = calculate_starting_delta(last_activity_layer, cost_gradient)

    calculate_remaning_deltas(rest, reversed_network_layers, [starting_delta])
  end

  defp calculate_starting_delta(activity_layer, cost_gradient) do
    %{input: input} = activity_layer

    input_gradient = Activation.apply_derivative(input, activity_layer)

    Matrix.multiply(cost_gradient, input_gradient)
  end

  defp calculate_remaning_deltas([], _, deltas) do
    deltas
  end

  defp calculate_remaning_deltas(activity_layers, network_layers, deltas) do
    [activity_layer|other_activity_layers] = activity_layers
    [network_layer|other_network_layers]   = network_layers

    %{input: input}     = activity_layer
    %{weights: weights} = network_layer

    [delta|_] = deltas

    weights_transposed = Matrix.transpose(weights)

    output_gradient = Matrix.dot(delta, weights_transposed)
    input_gradient  = Activation.apply_derivative(input, activity_layer)

    next_delta = Matrix.multiply(output_gradient, input_gradient)

    calculate_remaning_deltas(
      other_activity_layers,
      other_network_layers,
      [next_delta|deltas]
    )
  end

  defp calculate_weight_change(_, [], totals) do
    Enum.reverse(totals)
  end

  defp calculate_weight_change([a|as], [d|ds], total) do
    %{output: output} = a
    output_transposed = Matrix.transpose(output)
    result            = Matrix.dot(output_transposed, d)

    calculate_weight_change(as, ds, [result|total])
  end

  defp apply_changes(bias_change, weight_change, configuration, state) do
    %{network: %{layers: layers}} = state

    apply_changes(bias_change, weight_change, configuration, layers, state, [])
  end

  defp apply_changes([], [], _, [], state, new_layers) do
    %{network: network} = state

    new_network = put_in(network, [:layers], Enum.reverse(new_layers))

    put_in(state, [:network], new_network)
  end

  defp apply_changes(bias_changes, weight_changes, configuration, layers, state, new_layers) do
    %{learning_rate: rate} = configuration

    [bias_change|other_bias_changes]     = bias_changes
    [weight_change|other_weight_changes] = weight_changes

    [%{activity: activity, biases: biases, weights: weights}|other_layers] = layers

    new_biases = Matrix.multiply_with_scalar(bias_change, rate)
      |> Matrix.substract_inverse(biases)

    new_weights = Matrix.multiply_with_scalar(weight_change, rate)
      |> Matrix.substract_inverse(weights)

    new_layer = %{activity: activity, biases: new_biases, weights: new_weights}

    apply_changes(
      other_bias_changes,
      other_weight_changes,
      configuration,
      other_layers,
      state,
      [new_layer|new_layers]
    )
  end
end
