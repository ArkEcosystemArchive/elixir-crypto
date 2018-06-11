defmodule ArkElixir.MixProject do
  use Mix.Project

  def project do
    [
      app: :ark_crypto,
      version: "0.0.1",
      elixir: "~> 1.6",
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger, :hackney]
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:base58, "~> 0.1.0"},
      {:exbtc, "~> 0.1.3"},
      {:hackney, "~> 1.10"},
      {:temp, "~> 0.4"},

      {:mock, "~> 0.3.0", only: :test}
    ]
  end
end
