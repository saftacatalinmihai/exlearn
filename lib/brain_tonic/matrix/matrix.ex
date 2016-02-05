defmodule BrainTonic.Matrix do
  @moduledoc """
  Performs operations on matrices
  """

  @doc """
  Applies the given function on each element of the matrix
  """
  @spec apply([[]], ((number) -> number)) :: [[]]
  def apply(matrix, function) do
    matrix
    |> Enum.map(fn (row) ->
      row
      |> Enum.map(fn (element) ->
        function.(element)
      end)
    end)
  end
end
