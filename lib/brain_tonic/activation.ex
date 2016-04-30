defmodule BrainTonic.Activation do
  @moduledoc """
  Translates distributon names to functions
  """

  @doc """
  Returns the appropriate function
  """
  @spec determine(atom | map) :: map
  def determine(setup) do
    case setup do
      %{function: function, derivative: derivative}
          when function |> is_function and derivative |> is_function ->
        %{function: function, derivative: derivative}
      :identity -> identity_pair
      :binary   -> binary_pair
      :logistic -> logistic_pair
      :tanh     -> tanh_pair
      :arctan   -> arctan_pair
      :softsign -> softsign_pair
    end
  end

  @spec identity_pair :: map
  defp identity_pair do
    function   = fn (x) -> x end
    derivative = fn (_) -> 1 end

    %{function: function, derivative: derivative}
  end

  @spec binary_pair :: map
  defp binary_pair do
    function = fn
      x when x < 0 -> 0
      _            -> 1
    end

    derivative = fn
      # TODO return some numerical value for x == 0
      x when x == 0 -> :undefined
      _             -> 0
    end

    %{function: function, derivative: derivative}
  end

  @spec logistic_pair :: map
  defp logistic_pair do
    function   = fn (x) -> 1 / (1 + :math.exp(-x)) end
    derivative = fn (x) ->
      result = function.(x)
      result * (1 - result)
    end

    %{function: function, derivative: derivative}
  end

  @spec tanh_pair :: map
  defp tanh_pair do
    function   = fn (x) -> :math.tanh(x) end
    derivative = fn (x) ->
      result = function.(x)
      1 - result * result
    end

    %{function: function, derivative: derivative}
  end

  @spec arctan_pair :: map
  defp arctan_pair do
    function   = fn (x) -> :math.atan(x) end
    derivative = fn (x) -> 1 / (x * x + 1) end

    %{function: function, derivative: derivative}
  end

  @spec softsign_pair :: map
  defp softsign_pair do
    function   = fn (x) -> x / (1 + abs(x)) end
    derivative = fn (x) ->
      base = 1 + abs(x)
      1 / (base * base)
    end

    %{function: function, derivative: derivative}
  end
end
