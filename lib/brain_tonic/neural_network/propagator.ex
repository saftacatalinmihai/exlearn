defmodule BrainTonic.NeuralNetwork.Propagator do
  @moduledoc """
  Backpropagates the error trough a network
  """

  alias BrainTonic.{Matrix}

  @doc """
  Performs backpropagation
  """
  @spec back_propagate(map, list, number) :: map
  def back_propagate(state, activities, target) do
    %{
      network: %{
        biases:    biases,
        weights:   weights,
        objective: %{derivative: derivative}
      }
    } = state

    %{activity: activity, output: output} = activities

    cost_gradient = [derivative.(target, output)]

    deltas = calculate_detlas(weights, activity, cost_gradient)

    bias_change = deltas

    weight_chage = calculate_weight_change(activity, deltas, [])

    new_weights = calculate_new_weights(weights, weight_chage, state)
    new_biases = calculate_new_biases(biases, bias_change, state)

    create_new_network(state, new_weights, new_biases)
  end

  def calculate_detlas(ws, as, cost_gradient) do
    weights    = Enum.reverse(ws)
    activities = Enum.reverse(as)

    [activity|rest] = activities
    %{derivative: derivative, input: input} = activity

    value = Matrix.apply(input, derivative)

    delta = Matrix.multiply(cost_gradient, value)

    calculate_detla(weights, rest, [delta])
  end

  def calculate_detla(_, [], totals) do
    totals
  end

  def calculate_detla([weight|weights], [activity|activities], [delta|total]) do
    %{derivative: derivative, input: input} = activity

    transposed = Matrix.transpose(weight)

    prev = Matrix.multiply(transposed, delta)

    delta = Matrix.multiply(prev, Matrix.apply(input, derivative))

    calculate_detla(weights, activities, [delta|total])
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

  def calculate_weight_change([], [], totals) do
    Enum.reverse(totals)
  end

  def calculate_weight_change([activity|activities], [delta|deltas], total) do
    # result = Vector.dot_product(input, delta)
    #
    # calculate_weight_change(activities, deltas, [result|total])
    total
  end

  def calculate_bias_change(network, new_weights, new_biases) do
    # TODO
    network
  end
end
