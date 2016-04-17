defmodule BrainTonic.NeuralNetwork.Forwarder do
  @moduledoc """
  Feed forward functionality
  """

  alias BrainTonic.{Matrix}

  @doc """
  Propagates input forward trough a network and return the output
  """
  @spec feed_forward_for_output([number], map) :: [number]
  def feed_forward_for_output(input, state) do
    input
      |> full_network(state)
      |> calculate_output
  end

  @spec calculate_output(map) :: [number]
  defp calculate_output(network) do
    case network do
      %{weights: [w|[]]} -> w
      %{weights: [w1, w2|ws], biases: [b|bs], activity: [a|as]} ->
        %{function: f} = a
        output = Matrix.dot(w1, w2)
          |> Matrix.add([b])
          |> Matrix.apply(f)

        new_network = %{weights: [output|ws], biases: bs, activity: as}

        calculate_output(new_network)
    end
  end

  @doc """
  Propagates input forward trough a network and return the activity
  """
  @spec feed_forward_for_activity([number], map) :: [map]
  def feed_forward_for_activity(input, state) do
    input
      |> full_network(state)
      |> calculate_activity([])
  end

  @spec calculate_activity(map, [map]) :: map
  defp calculate_activity(network, activities) do
    case network do
      %{weights: [_|[]]} ->
        [%{output: output}|_] = activities
        result = Enum.reverse(activities)

        %{activity: result, output: output}
      %{weights: [w1, w2|ws], biases: [b|bs], activity: [a|as]} ->
        %{function: f, derivative: d} = a

        input    = Matrix.dot(w1, w2) |> Matrix.add([b])
        output   = input |> Matrix.apply(f)
        activity = %{derivative: d, input: input, output: output}

        new_network = %{weights: [output|ws], biases: bs, activity: as}

        calculate_activity(new_network, [activity|activities])
    end
  end

  # Prepends the input as a matrix to the weight list
  @spec full_network([number], map) :: map
  defp full_network(input, state) do
    %{network: network} = state
    %{weights: weights} = network

    put_in(network.weights, [[input]|weights])
  end
end
