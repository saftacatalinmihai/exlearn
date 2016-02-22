defmodule BrainTonic.Objective do
  @moduledoc """
  Translates objective names to functions
  """

  alias BrainTonic.Matrix

  @doc """
  Returns the appropriate function
  """
  @spec determine(map) :: (() -> float)
  def determine(setup) do
    case setup do
      %{objective: function} when function |> is_function ->
        function
      %{objective: :quadratic} ->
        &quadratic_cost(&1, &2)
    end
  end

  @spec quadratic_cost([], []) :: []
  defp quadratic_cost(output, expected) do
    1 / 2 * :math.sqrt(Matrix.dot_square_diff(output, expected))
  end
end
