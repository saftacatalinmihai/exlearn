defmodule BrainTonic.NeuralNetwork.Builder do
  @moduledoc """
  Build functionality
  """

  alias BrainTonic.{Activation, Distribution}

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

    layers          = [input_layer] ++ hidden_layers ++ [output_layer]
    random_function = Distribution.determine(random)

    %{
      activations: build_activations(layers),
      biases:      build_biases(layers, random_function),
      weights:     build_weights(layers, random_function)
    }
  end

  @spec build_activations([pos_integer,...]) :: list
  defp build_activations(layers) do
    build_activations(layers, [])
  end

  @spec build_activations([pos_integer,...], []) :: list
  defp build_activations([], total), do: total
  defp build_activations([_|[]], total), do: total
  defp build_activations([_, second | rest], total) do
    activation = Activation.determine(second)
    result     = total ++ [activation]

    build_activations([second] ++ rest, result)
  end

  @spec build_biases([pos_integer,...], (() -> float)) :: list
  defp build_biases(layers, random_function) do
    build_biases(layers, [], random_function)
  end

  @spec build_biases([pos_integer,...], [], (() -> float)) :: list
  defp build_biases([], total, _), do: total
  defp build_biases([_|[]], total, _), do: total
  defp build_biases([_, second | rest], total, random_function) do
    biases = build_list(second, random_function)
    result = total ++ [biases]

    build_biases([second] ++ rest, result, random_function)
  end

  @spec build_weights([pos_integer,...], (() -> float)) :: list
  defp build_weights(layers, random_function) do
    build_weights(layers, [], random_function)
  end

  @spec build_weights([pos_integer,...], [], (() -> float)) :: list
  defp build_weights([], total, _), do: total
  defp build_weights([_|[]], total, _), do: total
  defp build_weights([first, second | rest], total, random_function) do
    weights = build_matrix(first, second, random_function)
    result  = total ++ [weights]

    build_weights([second] ++ rest, result, random_function)
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
end
