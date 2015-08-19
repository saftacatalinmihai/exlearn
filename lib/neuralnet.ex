defmodule NerualNet do
  # The function to estimate
  # + target :: Integer -> Float
  defp target(x) do
    :math.sin x
  end
end
