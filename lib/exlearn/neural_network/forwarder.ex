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

    calculate_output(batch, layers)
  end

  defp calculate_output(output, []) do
    output
  end

  defp calculate_output(batch_input, [layer|rest]) do
    %{
      activity: %{function: function},
      biases:   biases,
      weights:  weights
    } = layer

    batch_output = Enum.map(batch_input, fn (sample) ->
      Matrix.dot([sample], weights)
        |> Matrix.add(biases)
        |> Matrix.apply(function)
        |> List.first()
    end)

    calculate_output(batch_output, rest)
  end

  @doc """
  Propagates input forward trough a network and return the activity
  """
  @spec forward_for_activity([number], map) :: [map]
  def forward_for_activity(batch, state) do
    %{network: %{layers: layers}} = state

    calculate_activity(batch, layers, [])
  end

  defp calculate_activity(output, [], activities) do
    %{activity: activities, output: output}
  end

  defp calculate_activity(batch_input, [layer|rest], activities) do
    %{
      activity: %{function: function, derivative: derivative},
      biases:   biases,
      weights:  weights
    } = layer

    activity = Enum.map(batch_input, fn (sample) ->
      input  = Matrix.dot(sample, weights) |> Matrix.add(biases)
      output = Matrix.apply(input, function)

      %{derivative: derivative, input: input, output: output}
    end)

    batch_output = Enum.map(activity, fn (element) -> element[:output] end)

    calculate_activity(batch_output, rest, [activity|activities])
  end
end
