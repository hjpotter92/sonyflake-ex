defmodule Sonyflake.MixProject do
  use Mix.Project

  @version "0.1.0"

  def project() do
    [
      app: :sonyflake_ex,
      version: @version,
      elixir: "~> 1.8",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      package: package(),
      description: description(),
      test_coverage: [tool: ExCoveralls]
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application() do
    [
      extra_applications: [:logger]
    ]
  end

  defp description(),
    do: "A distributed unique ID generator inspired by Twitter's Snowflake, rewritten in elixir"

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:excoveralls, "~> 0.5.7", only: :test},
      {:ex_doc, ">= 0.0.0", only: :dev, runtime: false}
    ]
  end

  defp files() do
    ["README.md", ".formatter.exs", "mix.exs", "mix.lock", "lib/**/*.ex"]
  end

  defp package() do
    [
      name: "sonyflake",
      licenses: ["MIT"],
      links: %{
        GitHub: "https://github.com/hjpotter92/sonyflake-ex",
        CodeCoverage: "https://app.codecov.io/gh/hjpotter92/sonyflake-ex"
      },
      files: files(),
      maintainers: ["hjpotter92"],
      source_url: "https://github.com/hjpotter92/sonyflake-ex"
    ]
  end
end
