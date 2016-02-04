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
      layers:  %{
        hidden: hidden_layers,
        input:  input_layer,
        output: output_layer
      },
      random: random
    } = setup

    layers    = [input_layer] ++ hidden_layers ++ [output_layer]
    random_function = determine_random_function(random)

    weights = build_network(layers, random_function)
    biases  = build_biases(layers, random_function)

    %{
      activations: [],
      biases:      biases,
      weights:     weights
    }
  end

  @spec build_network([pos_integer,...], (() -> float)) :: list
  defp build_network(layers, random_function) do
    build_network(layers, [], random_function)
  end

  @spec build_network([pos_integer,...], [], (() -> float)) :: list
  defp build_network([], total, _), do: total
  defp build_network([_|[]], total, _), do: total
  defp build_network([first, second | rest], total, random_function) do
    weights = build_matrix(first, second, random_function)
    result = total ++ [weights]
    build_network([second] ++ rest, result, random_function)
  end

  @spec build_biases([pos_integer,...], (() -> float)) :: list
  defp build_biases(layers, random_function) do
    build_biases(layers, [], random_function)
  end

  @spec build_biases([pos_integer,...], [], (() -> float)) :: list
  defp build_biases([], total, _), do: total
  defp build_biases([_|[]], total, _), do: total
  defp build_biases([first, second | rest], total, random_function) do
    weights = build_list(second, random_function)
    result = total ++ [weights]
    build_biases([second] ++ rest, result, random_function)
  end

  @spec build_matrix(%{}, %{}, (() -> float)) :: list
  defp build_matrix(%{size: rows}, columns, random_function) do
    Stream.unfold(rows, fn
      0 -> nil
      n -> {build_list(columns, random_function), n - 1}
    end)
    |> Enum.to_list
  end

  @spec build_list(%{}, (() -> float)) :: list
  defp build_list(%{size: size}, random_function) do
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
