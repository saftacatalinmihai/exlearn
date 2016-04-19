defmodule BrainTonic.NeuralNetwork.Propagator do
  @moduledoc """
  Backpropagates the error trough a network
  """

  alias BrainTonic.{Matrix, Vector}

  @doc """
  Performs backpropagation
  """
  @spec back_propagate(map, list, number) :: map
  def back_propagate(state, forwarded, {input, [target]}) do
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

    full_activity = [%{output: [input]}|activity]

    bias_change  = deltas
    weight_chage = calculate_weight_change(full_activity, deltas, [])

    new_weights = calculate_new_matrix(weights, weight_chage, state)
    new_biases  = calculate_new_matrix(biases, bias_change, state)

    create_new_network(state, new_weights, new_biases)
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
    totals
  end

  def calculate_detla([w|ws], [a|as], deltas) do
    %{derivative: d, input: i} = a

    [delta|_] = deltas

    wt = Matrix.transpose(w)

    output_gradient = Matrix.dot(delta, wt)
    input_gradient  = Matrix.apply(i, d)

    next_delta = Matrix.multiply(output_gradient, input_gradient)

    calculate_detla(ws, as, [next_delta|deltas])
  end

  def calculate_weight_change(_, [], totals) do
    Enum.reverse(totals)
  end

  def calculate_weight_change([a|as], [d|ds], total) do
    %{output: output} = a
    output_transposed = Matrix.transpose(output)
    result            = Matrix.dot(output_transposed, d)

    calculate_weight_change(as, ds, [result|total])
  end

  def calculate_new_matrix(matrix, chage, state) do
    %{setup: %{learning_rate: rate}} = state

    Stream.zip(matrix, chage)
      |> Enum.map(fn({x, y}) ->
        z = Matrix.multiplty_with_scalar(y, rate)
        Matrix.add(x,z)
      end)
      |> Enum.to_list
  end

  def create_new_network(state, new_weights, new_biases) do
    %{network: network} = state
    %{weights: weights, biases: biases} = network

    put_in(network, [:weights], new_weights)
    |> put_in([:biases], new_biases)
  end
end
