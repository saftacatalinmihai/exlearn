defmodule ExLearnTest do
  use ExUnit.Case, async: true

  test "version returns the semantic version" do
    regex  = ~r/\d+\.\d+\.\d+(\..*)?/
    result = ExLearn.version

    assert Regex.match?(regex, result)
  end
end
