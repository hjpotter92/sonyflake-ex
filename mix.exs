defmodule Sonyflake.MixProject do
  use Mix.Project

  @version "0.1.0"

  def project() do
    [
      app: :sonyflake_ex,
      version: @version,
      elixir: "~> 1.11",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      package: package(),
      description: description()
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
      links: [docs: "https://hexdocs.pm/sonyflake/"],
      files: files(),
      maintainers: ["hjpotter92"],
      source_url: "https://github.com/hjpotter92/sonyflake-ex"
    ]
  end
end
