defmodule BrainTonic.NeuralNetwork.Builder do
  @moduledoc """
  Build functionality
  """

  @doc """
  Initializez a neural network with the given setup
  """
  @spec initialize(map) :: map
  def initialize(setup) do
    %{
      random: random,
      sizes:  %{
        hidden: hidden_sizes,
        input:  input_size,
        output: output_size
      }
    } = setup

    column_sizes    = [input_size] ++ hidden_sizes ++ [output_size]
    random_function = determine_random_function(random)

    weights = build_network(column_sizes, random_function)
    biases  = build_list(length(weights), random_function)

    %{
      activations: [],
      biases:      biases,
      weights:     weights
    }
  end

  @spec build_network([pos_integer,...], (() -> float)) :: list
  defp build_network(column_sizes, random_function) do
    Enum.reduce(column_sizes, [], fn (size, total) ->
      List.insert_at(total, -1, build_list(size, random_function))
    end)
  end

  @spec build_list(pos_integer, (() -> float)) :: list
  defp build_list(size, random_function) do
    Stream.unfold(size, fn
      0 -> nil
      n -> {random_function.(), n - 1}
    end)
    |> Enum.to_list
  end

  @spec uniform_between({number(),number()}) :: float
  defp uniform_between({min, max}) do
    value = :rand.uniform
    value * (max - min) + min
  end

  @spec determine_random_function(map) :: (() -> float)
  defp determine_random_function(setup) do
    case setup do
      %{distribution: :uniform} ->
        %{range: range} = setup
        fn -> uniform_between(range) end
    end
  end
end
