defmodule ExLearn.NeuralNetwork.Forwarder do
  @moduledoc """
  Feed forward functionality
  """

  alias ExLearn.{Activation, Matrix}

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
      activity: activity,
      biases:   biases,
      weights:  weights
    } = layer

    output = Matrix.dot(input, weights)
      |> Matrix.add(biases)
      |> Activation.apply_function(activity)

    calculate_output(output, rest)
  end

  @spec forward_for_test([[number]], map) :: [[number]]
  def forward_for_test(batch, state) do
    %{network: %{layers: layers}} = state

    Enum.map(batch, fn({input, expected}) ->
      calculate_test({[input], expected}, layers)
    end)
  end

  defp calculate_test({output, _expected}, []) do
    List.first(output)
  end

  defp calculate_test({input, expected}, [layer|rest]) do
    %{
      activity: activity,
      biases:   biases,
      weights:  weights
    } = layer

    output = Matrix.dot(input, weights)
      |> Matrix.add(biases)
      |> Activation.apply_function(activity)

    calculate_test({output, expected}, rest)
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

      activity
        |> Map.put(:expected, expected)
        |> Map.put(:input, input)
    end)
  end

  defp calculate_activity(output, [], activities) do
    layer_output = List.first(output)

    %{activity: Enum.reverse(activities), output: layer_output}
  end

  defp calculate_activity(layer_input, [layer|rest], activities) do
    %{
      activity: activity,
      biases:   biases,
      weights:  weights
    } = layer

    input  = Matrix.dot(layer_input, weights) |> Matrix.add(biases)
    output = Activation.apply_function(input, activity)

    new_activity = Map.put(activity, :input, input)
      |> Map.put(:output, output)

    calculate_activity(output, rest, [new_activity|activities])
  end
end
