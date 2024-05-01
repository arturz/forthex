defmodule Forthex.Runner do
  @moduledoc false

  alias Forthex.{Interpreter, Lexer, Parser}

  def run(input) do
    input
    |> Lexer.tokenize()
    |> Parser.parse()
    |> Interpreter.interpret()
  end

  def run(input, state) do
    input
    |> Lexer.tokenize()
    |> Parser.parse()
    |> Interpreter.interpret(state)
  end
end
