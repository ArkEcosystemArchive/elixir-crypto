defmodule ArkEcosystem.Crypto.MixProject do
  use Mix.Project

  def project do
    [
      app: :arkecosystem_crypto,
      version: "0.1.0",
      elixir: "~> 1.6",
      start_permanent: Mix.env() == :prod,
      description: description(),
      package: package(),
      deps: deps(),
      name: "ArkEcosystem Elixir Crypto",
      source_url: "https://github.com/ArkEcosystem/elixir-crypto",
      test_coverage: [tool: ExCoveralls],
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
      {:excoveralls, "~> 0.9.1", only: :test},
      {:hackney, "~> 1.10"},
      {:jason, "~> 1.1"},
      {:kvx, "~> 0.1"},
      {:mock, "~> 0.3.0", only: :test},
      {:temp, "~> 0.4.5"}
    ]
  end

  defp description() do
    "A simple Cryptography Implementation in Elixir for the Ark Blockchain."
  end

  defp package() do
    [
      files: ["config", "lib", "priv", "mix.exs", "README*", "LICENSE*"],
      licenses: ["MIT"],
      links: %{"GitHub" => "https://github.com/ArkEcosystem/elixir-crypto"}
    ]
  end
end
