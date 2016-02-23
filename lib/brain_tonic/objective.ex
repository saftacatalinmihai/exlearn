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
      %{objective: %{function: function, derivative: derivative}}
          when function |> is_function and derivative |> is_function ->
        %{function: function, derivative: derivative}
      %{objective: :quadratic} ->
        function   = &quadratic_cost_function/2
        derivative = &quadratic_cost_partial_derivative/2
        %{function: function, derivative: derivative}
    end
  end

  @spec quadratic_cost_function([], []) :: []
  defp quadratic_cost_function(expected, actual) do
    1 / 2 * Matrix.dot_square_diff(expected, actual)
  end

  @spec quadratic_cost_partial_derivative([], []) :: []
  defp quadratic_cost_partial_derivative(expected, actual) do
    Matrix.substract(actual, expected)
  end
end
