defmodule Forthex.Interpreter.Dictionary.MathWords do
  @moduledoc false

  import Forthex.Interpreter.Dictionary.Helpers

  alias Forthex.Interpreter.State

  @doc "( n1 n2 -- n3 )"
  def plus(%State{} = state) do
    {value2, state} = pop(state)
    {value1, state} = pop(state)
    push(state, value1 + value2)
  end

  @doc "( n1 n2 -- n3 )"
  def minus(%State{} = state) do
    {value2, state} = pop(state)
    {value1, state} = pop(state)
    push(state, value1 - value2)
  end

  @doc "( n1 n2 -- n3 )"
  def multiply(%State{} = state) do
    {value2, state} = pop(state)
    {value1, state} = pop(state)
    push(state, value1 * value2)
  end

  @doc "( n1 n2 -- n3 )"
  def divide(%State{} = state) do
    {value2, state} = pop(state)
    {value1, state} = pop(state)
    push(state, div(value1, value2))
  end
end
