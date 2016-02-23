defmodule ObjectiveTest do
  use ExUnit.Case, async: true

  alias BrainTonic.Objective

  test "#determine return the quadratic function" do
    first    = [1, 2, 3]
    second   = [1, 2, 5]
    expected = 2

    setup = %{objective: :quadratic}

    %{function: function, derivative: derivative} = Objective.determine(setup)

    assert function.(first, second) == expected
  end
end
