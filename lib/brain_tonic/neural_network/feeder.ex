defmodule BrainTonic.NeuralNetwork.Feeder do
  @moduledoc """
  Feeds input to the NeuralNetwork
  """

  alias BrainTonic.NeuralNetwork

  def feed(parameters, network) do
    %{epochs: epochs} = parameters
    feed_network(network, parameters, epochs)
  end

  @spec feed_network(map, pid, number) :: any
  defp feed_network(parameters, network, 0),     do: :ok
  defp feed_network(parameters, network, epochs) do
    %{batch_size: batch_size, data: data, data_size: data_size} = parameters

    batches = Enum.shuffle(data) |> Enum.chunk(batch_size)

    NeuralNetwork.configure(network, parameters)

    Enum.each(batches, fn (batch) ->
      NeuralNetwork.train(batch, network)
    end)

    feed_network(network, parameters, epochs - 1)
  end
end
