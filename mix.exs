defmodule BrainTonic.Mixfile do
  use Mix.Project

  def project do
    [
      app:             :braintonic,
      version:         "0.0.1",
      elixir:          "1.2.1",
      build_embedded:  Mix.env == :prod,
      start_permanent: Mix.env == :prod,
      deps:            deps
    ]
  end

  def application do
    [applications: [:logger]]
  end

  defp deps do
    [{:dialyxir, "0.3.2", only: [:dev]}]
  end
end
