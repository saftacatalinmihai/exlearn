defmodule BrainTonic.NeuralNetwork.Propagator do
  @moduledoc """
  Propagates input trough a network
  """

  alias BrainTonic.{Matrix, Vector}

  @doc """
  Propagates input forward trough a network and return the result
  """
  @spec feed_forward([number], map) :: map
  def feed_forward(input, state) do
    %{network: network} = state
    %{weights: weights} = network

    full_network = put_in(network.weights, [[input]|weights])

    reversed_activity         = calculate_activity(full_network, [])
    [%{output: [output]} | _] = reversed_activity
    new_activity              = Enum.reverse(reversed_activity)

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
        %{function: f, derivative: d} = a

        input  = Matrix.multiply(w1, w2) |> Matrix.add([b])
        output = input |> Matrix.apply(f)
        new_a  = %{function: f, derivative: d, input: input, output: output}

        new_network = %{weights: [output | ws], biases: bs, activity: as}

        calculate_activity(new_network, [new_a | activity])
    end
  end

  @doc """
  Performs backpropagation
  """
  @spec back_propagate(map, number) :: map
  def back_propagate(state, target) do
    %{
      network: %{
        activity:  activity,
        biases:    biases,
        weights:   weights,
        output:    output,
        objective: %{derivative: derivative}
      }
    } = state

    cost_gradient = derivative.(target, output)

    deltas = calculate_detlas(weights, cost_gradient, activity)
    bias_change = deltas
    weight_chage = calculate_weight_change(activity, deltas, [])

    new_weights = calculate_new_weights(weights, weight_chage, state)
    new_biases = calculate_new_biases(biases, bias_change, state)

    create_new_network(state, new_weights, new_biases)
  end

  def calculate_detlas(ws, cost_gradient, as) do
    weights    = Enum.reverse(ws)
    activities = Enum.reverse(as)

    [activity|rest] = activities
    %{derivative: derivative, input: input} = activity

    [value] = Matrix.apply(input, derivative)

    delta = Vector.multiply(cost_gradient, value)

    calculate_detlas(weights, cost_gradient, rest, [[delta]])
  end

  def calculate_detlas([], cost_gradient, [activity], totals) do
    totals
  end

  def calculate_detlas([weight|weights], cost_gradient, [activity|activities], [delta|total]) do
    %{derivative: derivative, input: input} = activity

    transposed = Matrix.transpose(weight)

    [prev] = Matrix.multiply(transposed, delta)

    delta = Vector.multiply(prev, [derivative.(input)])

    calculate_detlas(weights, cost_gradient, activities, [delta|total])
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

  def calculate_weight_change([activity|activities], [delta, deltas], total) do
    result = Vector.dot_product(activity, delta)

    calculate_weight_change(activities, deltas, [result|total])
  end

  def calculate_bias_change(network, new_weights, new_biases) do
    # TODO
    network
  end
end
