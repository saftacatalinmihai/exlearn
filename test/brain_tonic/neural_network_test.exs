defmodule NeuralNetworkTest do
  use ExUnit.Case, async: true

  alias BrainTonic.NeuralNetwork

  test "initialize returns a process" do
    setup = %{}
    result = setup |> NeuralNetwork.initialize
    assert result |> is_pid
  end
end
