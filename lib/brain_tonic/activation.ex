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
      :identity      -> identity_pair
      :binary        -> binary_pair
      :logistic      -> logistic_pair
      :tanh          -> tanh_pair
      :arctan        -> arctan_pair
      :softsign      -> softsign_pair
      :relu          -> relu_pair
      :softplus      -> softplus_pair
      :bent_identity -> bent_identity_pair
      :sinusoid      -> sinusoid_pair
      :sinc          -> sinc_pair
      {:prelu, alpha: alpha} -> prelu_pair(alpha)
      {:elu,   alpha: alpha} -> elu_pair(alpha)
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

  @spec relu_pair :: map
  defp relu_pair do
    function = fn
      x when x < 0 -> 0
      x            -> x
    end

    derivative = fn
      x when x < 0 -> 0
      _            -> 1
    end

    %{function: function, derivative: derivative}
  end

  @spec softplus_pair :: map
  defp softplus_pair do
    function   = fn (x) -> :math.log(1 + :math.exp(x)) end
    derivative = fn (x) -> 1 / (1 + :math.exp(-x)) end

    %{function: function, derivative: derivative}
  end

  @spec bent_identity_pair :: map
  defp bent_identity_pair do
    function   = fn (x) -> (:math.sqrt(x * x + 1) - 1) / 2 + x end
    derivative = fn (x) -> x / (2 * :math.sqrt(x * x + 1)) + 1 end

    %{function: function, derivative: derivative}
  end

  @spec sinusoid_pair :: map
  defp sinusoid_pair do
    function   = fn (x) -> :math.sin(x) end
    derivative = fn (x) -> :math.cos(x) end

    %{function: function, derivative: derivative}
  end

  @spec sinc_pair :: map
  defp sinc_pair do
    function   = fn
      x when x == 0 -> 1
      x             -> :math.sin(x) / x
    end

    derivative = fn
      x when x == 0 -> 0
      x             -> :math.cos(x) / x - :math.sin(x) / (x * x)
    end

    %{function: function, derivative: derivative}
  end

  @spec prelu_pair(number) :: map
  defp prelu_pair(alpha) do
    function = fn
      x when x < 0 -> alpha * x
      x            -> x
    end

    derivative = fn
      x when x < 0 -> alpha
      _            -> 1
    end

    %{function: function, derivative: derivative}
  end

  @spec elu_pair(number) :: map
  defp elu_pair(alpha) do
    function = fn
      x when x < 0 -> alpha * (:math.exp(x) - 1)
      x            -> x
    end

    derivative = fn
      x when x < 0 -> function.(x) + alpha
      _            -> 1
    end

    %{function: function, derivative: derivative}
  end
end
