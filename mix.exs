defmodule Scanner.MixProject do
  use Mix.Project

  def project do
    [
      app: :scanner,
      version: "0.1.0",
      elixir: "~> 1.6",
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger],
      mod: {Scanner.Application, []}
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:benchee, "~> 0.11", only: :dev},
      {:benchee_html, "~> 0.5", only: :dev},
      {:flow, "~> 0.14"},
      {:mix_test_watch, "~> 0.6", only: :dev, runtime: false}
    ]
  end
end
