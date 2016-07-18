defmodule ExLearn.Mixfile do
  use Mix.Project

  def project do
    [
      app:               :ExLearn,
      version:           "0.1.0",
      elixir:            "1.3.1",
      build_embedded:    Mix.env == :prod,
      start_permanent:   Mix.env == :prod,
      deps:              deps,
      test_coverage:     [tool: ExCoveralls],
      preferred_cli_env: [coveralls: :test, "coveralls.html": :test]
    ]
  end

  def application do
    [applications: [:logger]]
  end

  defp deps do
    [
      {:benchfella,  "0.3.2", only: :dev },
      {:dialyxir,    "0.3.5", only: :dev },
      {:excoveralls, "0.5.5", only: :test}
    ]
  end
end
