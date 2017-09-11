defmodule Box.Mixfile do
  use Mix.Project

  def project do
    [app: :box,
     version: "0.1.0",
     elixir: "~> 1.4",
     build_embedded: Mix.env == :prod,
     start_permanent: Mix.env == :prod,
     deps: deps()]
  end

  # Configuration for the OTP application
  #
  # Type "mix help compile.app" for more information
  def application do
    # Specify extra applications you'll use from Erlang/Elixir
    [extra_applications: [:logger, :httpotion],
     mod: {Box.Application, []}]
  end

  # Dependencies can be Hex packages:
  #
  #   {:my_dep, "~> 0.3.0"}
  #
  # Or git/path repositories:
  #
  #   {:my_dep, git: "https://github.com/elixir-lang/my_dep.git", tag: "0.1.0"}
  #
  # Type "mix help deps" for more examples and options
  defp deps do
    [
      # JWT
      {:joken, "~> 1.1"},
      {:libsodium, "~> 0.0.3"},
      {:keccakf1600, "~> 0.0.1"},

      {:httpotion, "~> 3.0.2"},
      {:poison, "~> 3.1"},
      {:uuid, "~> 1.1"}
    ]
  end
end
