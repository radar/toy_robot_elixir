defmodule ToyRobot.MixProject do
  use Mix.Project

  def project do
    [
      app: :toy_robot,
      version: "0.1.0",
      elixir: "~> 1.8",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      escript: escript(),
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger],
      mod: {ToyRobot.Application, []}
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:uuid, "~> 1.1.8"},
    ]
  end

  defp escript do
    [main_module: ToyRobot.CLI]
  end
end
