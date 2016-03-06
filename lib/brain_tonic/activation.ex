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
    end
  end

  @spec identity_pair :: map
  defp identity_pair do
    function   = fn (x) -> x end
    derivative = fn (_) -> 1 end

    %{function: function, derivative: derivative}
  end
end
