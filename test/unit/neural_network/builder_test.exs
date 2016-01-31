defmodule BuilderTest do
  use ExUnit.Case

  alias BrainTonic.NeuralNetwork.Builder

  test "initialize return a map" do
    parameters = %{
      sizes: %{
        hidden: [1],
        output: 1
      }
    }
    result = parameters |> Builder.initialize
    assert result |> is_map
  end

  test "build_network returns a list of lists" do
    network_sizes = [1]
    result = Builder.build_network(network_sizes)
    [inner] = result
    assert result |> is_list
    assert inner |> is_list
  end

  test "build_list returns a list" do
    list_size = 1
    result = Builder.build_list(list_size)
    assert result |> is_list
  end
end
