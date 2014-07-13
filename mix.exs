defmodule Hangman.Mixfile do
  use Mix.Project

  def project do
    [ app: :hangman,
      version: "0.0.1",
      elixir: "~> 0.14.3",
      deps: deps,
      escript: [
        main_module: Hangman
      ]
    ]
  end

  # Configuration for the OTP application
  def application do
    []
  end

  # Returns the list of dependencies in the format:
  # { :foobar, git: "https://github.com/elixir-lang/foobar.git", tag: "0.1" }
  #
  # To specify particular versions, regardless of the tag, do:
  # { :barbat, "~> 0.1", github: "elixir-lang/barbat" }
  defp deps do
    []
  end
end
