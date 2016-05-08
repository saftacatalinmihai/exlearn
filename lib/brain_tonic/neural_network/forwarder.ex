defmodule BrainTonic.NeuralNetwork.Forwarder do
  @moduledoc """
  Feed forward functionality
  """

  alias BrainTonic.Matrix

  @doc """
  Propagates input forward trough a network and return the output
  """
  @spec forward_for_output([[number]], map) :: [[number]]
  def forward_for_output(inputs, state) do
    inputs
      |> full_network(state)
      |> calculate_output
  end

  @spec calculate_output(map) :: [number]
  defp calculate_output(network) do
    case network do
      %{weights: [batch|[]]} ->
        Enum.map(batch, fn (sample) -> List.first(sample) end)
      %{weights: [batch, w|ws], biases: [b|bs], activity: [a|as]} ->
        %{function: f} = a

        output = Enum.map(batch, fn (sample) ->
          Matrix.dot(sample, w)
            |> Matrix.add([b])
            |> Matrix.apply(f)
        end)

        new_network = %{weights: [output|ws], biases: bs, activity: as}

        calculate_output(new_network)
    end
  end

  @doc """
  Propagates input forward trough a network and return the activity
  """
  @spec forward_for_activity([number], map) :: [map]
  def forward_for_activity(input, state) do
    input
      |> full_network(state)
      |> calculate_activity([])
  end

  @spec calculate_activity(map, [map]) :: map
  defp calculate_activity(network, activities) do
    case network do
      %{weights: [_|[]]} ->
        Matrix.transpose(activities)
          |> Enum.map(fn (element) ->
            [%{output: [out]}|_] = element
            result = Enum.reverse(element)

            %{activity: result, output: out}
          end)
      %{weights: [batch, w|ws], biases: [b|bs], activity: [a|as]} ->
        %{function: f, derivative: d} = a

        activity = Enum.map(batch, fn (sample) ->
          input  = Matrix.dot(sample, w) |> Matrix.add([b])
          output = input |> Matrix.apply(f)

          %{derivative: d, input: input, output: output}
        end)

        output      = Enum.map(activity, fn (element) -> element[:output] end)
        new_network = %{weights: [output|ws], biases: bs, activity: as}

        calculate_activity(new_network, [activity|activities])
    end
  end

  # Prepends the input as a matrix to the weight list
  @spec full_network([[number]], map) :: map
  defp full_network(inputs, state) do
    %{network: network} = state
    %{weights: weights} = network

    input_list = Enum.map(inputs, fn (input) -> [input] end)

    put_in(network, [:weights], [input_list|weights])
  end
end
