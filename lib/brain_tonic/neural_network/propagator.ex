defmodule BrainTonic.NeuralNetwork.Propagator do
  @moduledoc """
  Backpropagates the error trough a network
  """

  alias BrainTonic.{Matrix, Vector}

  @doc """
  Performs backpropagation
  """
  @spec back_propagate(map, list, number) :: map
  def back_propagate(state, forwarded, [target]) do
    %{
      network: %{
        biases:    biases,
        weights:   weights,
        objective: %{derivative: derivative}
      }
    } = state

    %{activity: activity, output: [output]} = forwarded

    cost_gradient = [derivative.(target, output)]

    deltas = calculate_detlas(weights, activity, cost_gradient)

    #
    # bias_change = deltas
    #
    # weight_chage = calculate_weight_change(activity, deltas, [])
    #
    # new_weights = calculate_new_weights(weights, weight_chage, state)
    # new_biases = calculate_new_biases(biases, bias_change, state)
    #
    # create_new_network(state, new_weights, new_biases)
  end

  def calculate_detlas(ws, as, cost_gradient) do
    weights    = Enum.reverse(ws)
    activities = Enum.reverse(as)

    [activity|rest] = activities
    %{derivative: derivative, input: input} = activity

    input_gradient = Matrix.apply(input, derivative)

    delta = Matrix.multiply(cost_gradient, input_gradient)

    calculate_detla(weights, rest, [delta])
  end

  def calculate_detla(_, [], totals) do
    Enum.reverse(totals)
  end

  def calculate_detla([w|ws], [a|as], deltas) do
    %{derivative: d, input: i} = a

    [delta|_] = deltas

    wt = Matrix.transpose(w)

    IO.inspect "#########################"
    IO.inspect w
    IO.inspect wt
    IO.inspect delta
    output_gradient = Matrix.dot(delta, wt)
    input_gradient  = Matrix.apply(i, d)
    IO.inspect output_gradient
    IO.inspect input_gradient

    next_delta = Matrix.multiply(output_gradient, input_gradient)
    IO.inspect delta
    IO.inspect "#########################"

    calculate_detla(ws, as, [next_delta|deltas])
  end
  #
  # def calculate_new_weights(weights, weight_chage, network) do
  #   # TODO
  #   weights
  # end
  #
  # def calculate_new_biases(biases, bias_change, network) do
  #   # TODO
  #   biases
  # end
  #
  # def create_new_network(network, new_weights, new_biases) do
  #   # TODO
  #   network
  # end
  #
  # def calculate_weight_change([], [], totals) do
  #   Enum.reverse(totals)
  # end
  #
  # def calculate_weight_change([activity|activities], [delta|deltas], total) do
  #   # result = Vector.dot_product(input, delta)
  #   #
  #   # calculate_weight_change(activities, deltas, [result|total])
  #   total
  # end
  #
  # def calculate_bias_change(network, new_weights, new_biases) do
  #   # TODO
  #   network
  # end
end
