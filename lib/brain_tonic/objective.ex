defmodule BrainTonic.Objective do
  @moduledoc """
  Translates objective names to functions
  """

  alias BrainTonic.{Vector}

  @doc """
  Returns the appropriate function
  """
  @spec determine(atom | map) :: map
  def determine(setup) do
    case setup do
      %{function: function, derivative: derivative}
          when function |> is_function and derivative |> is_function ->
        %{function: function, derivative: derivative}
      :quadratic -> quadratic_pair
    end
  end

  @spec quadratic_pair :: map
  defp quadratic_pair do
    function   = &quadratic_cost_function/2
    derivative = &quadratic_cost_partial_derivative/2

    %{function: function, derivative: derivative}
  end

  @spec quadratic_cost_function([number], [number]) :: float
  defp quadratic_cost_function(expected, actual) do
    1 / 2 * Vector.dot_square_difference(expected, actual)
  end

  @spec quadratic_cost_partial_derivative([], []) :: []
  defp quadratic_cost_partial_derivative(expected, actual) do
    Vector.substract(actual, expected)
  end
end
