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
      :cross_entropy -> cross_entropy_pair
      :quadratic     -> quadratic_pair
      :softmax       -> softmax_pair
    end
  end

  @spec cross_entropy_pair :: map
  defp cross_entropy_pair do
    function   = &cross_entropy_function/3
    derivative = &cross_entropy_derivative/2

    %{function: function, derivative: derivative}
  end

  @spec cross_entropy_function([number], [number], non_neg_integer) :: float
  defp cross_entropy_function(expected, actual, data_size) do
    cross_entropy = Enum.zip(expected, actual)
      |> Enum.map(fn({x, y}) ->
        x * :math.log(y) + (1 - x) * :math.log(1 - y)
      end)
      |> Enum.sum

    -1 / data_size * cross_entropy
  end

  @spec cross_entropy_derivative([number], [number]) :: [number]
  defp cross_entropy_derivative(expected, actual) do
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

  @spec softmax_pair :: map
  defp softmax_pair do
    function   = &softmax_function/2
    derivative = &softmax_derivative/2

    %{function: function, derivative: derivative}
  end

  @spec softmax_function([number], [number]) :: float
  defp softmax_function(_expected, _actual) do
  end

  @spec softmax_derivative([], []) :: []
  defp softmax_derivative(_expected, _actual) do
  end
end
