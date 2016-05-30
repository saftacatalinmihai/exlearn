defmodule BrainTonic.Mixfile do
  use Mix.Project

  def project do
    [
      app:             :braintonic,
      version:         "0.0.1",
      elixir:          "1.2.5",
      build_embedded:  Mix.env == :prod,
      start_permanent: Mix.env == :prod,
      deps:            deps
    ]
  end

  def application do
    [applications: [:logger]]
  end

  defp deps do
    [
      {:benchwarmer, "0.0.2", only: [:dev]},
      {:dialyxir,    "0.3.3", only: [:dev]}
    ]
  end
end
