defmodule NerualNet do
  # The function to estimate
  @spec target(float) :: float # +
  def target(x) do
    :math.sin x
  end
end
