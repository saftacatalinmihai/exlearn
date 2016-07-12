defmodule ExLearn.NeuralNetwork.Forwarder do
  @moduledoc """
  Feed forward functionality
  """

  alias ExLearn.Matrix

  @doc """
  Propagates input forward trough a network and return the output
  """
  @spec forward_for_output([[number]], map) :: [[number]]
  def forward_for_output(batch, state) do
    %{network: %{layers: layers}} = state

    Enum.map(batch, fn(sample) ->
      calculate_output([sample], layers)
    end)
  end

  defp calculate_output(output, []) do
    List.first(output)
  end

  defp calculate_output(input, [layer|rest]) do
    %{
      activity: %{function: function},
      biases:   biases,
      weights:  weights
    } = layer

    output = Matrix.dot(input, weights)
      |> Matrix.add(biases)
      |> Matrix.apply(function)

    calculate_output(output, rest)
  end

  @doc """
  Propagates input forward trough a network and return the activity
  """
  @spec forward_for_activity([number], map) :: [map]
  def forward_for_activity(batch, state) do
    %{network: %{layers: layers}} = state

    Enum.map(batch, fn(sample) ->
      {input, expected} = sample

      activity = calculate_activity([input], layers, [])

      Map.put(activity, :expected, expected)
    end)
  end

  defp calculate_activity(output, [], activities) do
    layer_output = List.first(output)

    %{activity: Enum.reverse(activities), output: layer_output}
  end

  defp calculate_activity(layer_input, [layer|rest], activities) do
    %{
      activity: %{function: function, derivative: derivative},
      biases:   biases,
      weights:  weights
    } = layer

    input  = Matrix.dot(layer_input, weights) |> Matrix.add(biases)
    output = Matrix.apply(input, function)

    activity =  %{derivative: derivative, input: input, output: output}

    calculate_activity(output, rest, [activity|activities])
  end
end
