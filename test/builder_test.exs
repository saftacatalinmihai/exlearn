defmodule BuilderTest do
  use ExUnit.Case

  alias BrainTonic.Builder, as: B

  test "initialize_neural_network return a map" do
    parameters = %{
      hidden_layers_sizes: [1],
      hidden_layers_number: 1,
      input_size: 1,
      learning_rate: 0.5,
      output_layer_size: 1
    }
    result = parameters |> B.initialize_neural_network
    assert result |> is_map
  end
end
