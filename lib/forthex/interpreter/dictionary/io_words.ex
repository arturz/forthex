defmodule Forthex.Interpreter.Dictionary.IOWords do
  @moduledoc false

  import Forthex.Interpreter.Dictionary.Helpers

  alias Forthex.Interpreter.State

  @doc "( -- )"
  def cr(%State{} = state) do
    IO.write("\n")
    state
  end

  @doc "( n -- )"
  def emit(%State{} = state) do
    {value, state} = pop(state)
    IO.write(<<value::utf8>>)
    state
  end

  @doc "( n -- )"
  def spaces(%State{} = state) do
    {value, state} = pop(state)
    IO.write(String.duplicate(" ", value))
    state
  end

  @doc "( -- n )"
  def accept(%State{} = state) do
    with data when is_binary(data) <- IO.read(:line),
         data <- String.trim(data),
         {int, ""} <- Integer.parse(data) do
      push(state, int)
    else
      _ -> push(state, 0)
    end
  end
end
