defmodule BrainTonic.NeuralNetwork.Activation do
  @moduledoc """
  Translates distributon names to functions
  """

  @doc """
  Returns the appropriate function
  """
  @spec determine(map) :: (() -> float)
  def determine(setup) do
    case setup do
      %{function: function} when function |> is_function ->
        function
      %{activation: :identity} ->
        fn (x) -> x end
    end
  end
end
