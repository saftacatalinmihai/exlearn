defmodule ExLearn.Objective do
  @moduledoc """
  Translates objective names to functions
  """

  alias ExLearn.Vector

  @doc """
  Returns the appropriate function
  """
  @spec determine(atom | map) :: map
  def determine(setup) do
    case setup do
      %{function: function, derivative: derivative}
          when function |> is_function and derivative |> is_function ->
        %{function: function, derivative: derivative}
      :cross_entropy           -> cross_entropy_pair
      :negative_log_likelihood -> negative_log_likelihood_pair
      :quadratic               -> quadratic_pair
    end
  end

  @spec cross_entropy_pair :: map
  defp cross_entropy_pair do
    function   = &cross_entropy_function/3
    derivative = &cross_entropy_partial_derivative/2

    %{function: function, derivative: derivative}
  end

  @spec cross_entropy_function([number], [number], non_neg_integer) :: float
  defp cross_entropy_function(expected, actual, data_size) do
    binary_entropy_sum = Enum.zip(expected, actual)
      |> Enum.map(fn({x, y}) ->
        x * :math.log(y) + (1 - x) * :math.log(1 - y)
      end)
      |> Enum.sum

    -1 / data_size * binary_entropy_sum
  end

  @spec cross_entropy_partial_derivative([number], [number]) :: [number]
  defp cross_entropy_partial_derivative(expected, actual) do
    Vector.substract(actual, expected)
  end

  @spec quadratic_pair :: map
  defp quadratic_pair do
    function   = &quadratic_cost_function/3
    derivative = &quadratic_cost_partial_derivative/2

    %{function: function, derivative: derivative}
  end

  @spec quadratic_cost_function([number], [number], non_neg_integer) :: float
  defp quadratic_cost_function(expected, actual, data_size) do
    1 / (2 * data_size) * Vector.dot_square_difference(expected, actual)
  end

  @spec quadratic_cost_partial_derivative([], []) :: []
  defp quadratic_cost_partial_derivative(expected, actual) do
    Vector.substract(actual, expected)
  end

  @spec negative_log_likelihood_pair :: map
  defp negative_log_likelihood_pair do
    function   = &negative_log_likelihood_function/3
    derivative = &negative_log_likelihood_partial_derivative/2

    %{function: function, derivative: derivative}
  end

  @spec negative_log_likelihood_function([number], [number], non_neg_integer) :: float
  defp negative_log_likelihood_function(expected, actual, data_size) do
    -1 / data_size * :math.log(Enum.sum(Vector.multiply(expected, actual)))
  end

  @spec negative_log_likelihood_partial_derivative([number], [number]) :: []
  defp negative_log_likelihood_partial_derivative(expected, actual) do
    Vector.substract(actual, expected)
  end
end
