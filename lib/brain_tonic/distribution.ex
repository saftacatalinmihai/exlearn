defmodule BrainTonic.Distribution do
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
      %{distribution: :uniform} ->
        %{range: range} = setup
        fn -> uniform_between(range) end
    end
  end

  @spec uniform_between({number, number}) :: float
  defp uniform_between({min, max}) do
    value = :rand.uniform
    value * (max - min) + min
  end
end
