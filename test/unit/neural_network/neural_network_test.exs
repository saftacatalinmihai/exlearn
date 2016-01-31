defmodule NeuralNetworkTest do
  use ExUnit.Case

  alias BrainTonic.NeuralNetwork, as: NN

  test "initialize returns a process" do
    setup = %{}
    result = setup |> NN.initialize
    assert result |> is_pid
  end
end
