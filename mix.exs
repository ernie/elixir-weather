defmodule Weather.Mixfile do
  use Mix.Project

  def project do
    [app: :weather,
     version: "0.0.1",
     name: "Weather",
     elixir: "~> 0.13.0",
     escript_main_module: Weather.CLI,
     deps: deps]
  end

  # Configuration for the OTP application
  #
  # Type `mix help compile.app` for more information
  def application do
    [ applications: [ :httpotion ],
      mod: { Weather, [] } ]
  end

  # List all dependencies in the format:
  #
  # { :foobar, git: "https://github.com/elixir-lang/foobar.git", tag: "0.1" }
  #
  # Type `mix help deps` for more examples and options
  defp deps do
    [
      { :httpotion, github: "myfreeweb/httpotion" },
      { :ex_doc,    github: "elixir-lang/ex_doc" }
    ]
  end
end
