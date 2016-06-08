defmodule DistributionTest do
  use ExUnit.Case, async: true

  alias ExLearn.Distribution

  test "#determine return the given function" do
    range    = {-2, 3}
    expected = 1

    given_function = fn ({min, max}) -> min + max end

    setup = %{distribution: %{function: given_function}, range: range}

    function = Distribution.determine(setup)

    assert function.() == expected
  end

  test "#determine return the uniform function applied to the range" do
    min   = -2
    max   = 3
    range = {min, max}

    setup = %{distribution: :uniform, range: range}

    function = Distribution.determine(setup)

    result = function.()
    assert result >= min && result <= max
  end
end
