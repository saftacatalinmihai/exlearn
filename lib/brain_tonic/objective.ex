defmodule BrainTonic.Objective do
  @moduledoc """
  Translates objective names to functions
  """

  alias BrainTonic.Matrix

  @doc """
  Returns the appropriate function
  """
  @spec determine(map) :: (() -> float)
  def determine(setup, size \\ 0) do
    case setup do
      %{objective: function} when function |> is_function ->
        function
      %{objective: :quadratic} ->
        &quadratic_cost(size, &1, &2)
    end
  end

  @spec quadratic_cost(pos_integer, [], []) :: []
  defp quadratic_cost(size, output, expected) do
    1 / 2 * size * :math.sqrt(Matrix.dot_suare_diff(output, expected))
  end
end
