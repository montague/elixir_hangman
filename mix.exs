defmodule Hangman.Mixfile do
  use Mix.Project

  def project do
    [ app: :hangman,
      version: "0.0.1",
      elixir: "~> 0.15.1",
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

  defp deps do
    []
  end
end
