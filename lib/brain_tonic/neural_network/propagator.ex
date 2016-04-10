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

  @doc """
  Propagates input forward trough a network and return the output
  """
  @spec feed_forward_for_output([number], map) :: [number]
  def feed_forward_for_output(input, state) do
    input
      |> full_network(state)
      |> calculate_network_output
  end

  @spec calculate_network_output(map) :: [number]
  defp calculate_network_output(network) do
    case network do
      %{weights: [w|[]]} ->
        [output] = w
        output
      %{weights: [w1, w2|ws], biases: [b|bs], activity: [a|as]} ->
        %{function: f} = a

        output = Matrix.multiply(w1, w2)
          |> Matrix.add([b])
          |> Matrix.apply(f)

        new_network = %{weights: [output|ws], biases: bs, activity: as}

        calculate_network_output(new_network)
    end
  end

  @doc """
  Propagates input forward trough a network and return the activity
  """
  @spec feed_forward_for_activity([number], map) :: [map]
  def feed_forward_for_activity(input, state) do
    input
      |> full_network(state)
      |> calculate_network_activity([])
  end

  @spec calculate_network_activity(map, [map]) :: map
  defp calculate_network_activity(network, activities) do
    case network do
      %{weights: [_|[]]} ->
        activities
      %{weights: [w1, w2|ws], biases: [b|bs], activity: [a|as]} ->
        %{function: f} = a

        input    = Matrix.multiply(w1, w2) |> Matrix.add([b])
        output   = input |> Matrix.apply(f)
        activity = %{input: input, output: output}

        new_network = %{weights: [output|ws], biases: bs, activity: as}

        calculate_activity(new_network, [activity|activities])
    end
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

  # Prepends the input as a matrix to the weight list
  @spec full_network([number], map) :: map
  defp full_network(input, state) do
    %{network: network} = state
    %{weights: weights} = network

    put_in(network.weights, [[input]|weights])
  end
end
