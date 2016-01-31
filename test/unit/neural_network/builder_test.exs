defmodule BuilderTest do
  use ExUnit.Case

  alias BrainTonic.NeuralNetwork.Builder

  test "initialize return a map" do
    parameters = %{
      hidden_layers_sizes: [1],
      hidden_layers_number: 1,
      output_layer_size: 1
    }
    result = parameters |> Builder.initialize
    assert result |> is_map
  end
end
