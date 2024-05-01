defmodule Forthex.Interpreter.Dictionary.LogicWords do
  @moduledoc false

  import Forthex.Interpreter.Dictionary.Helpers

  alias Forthex.Interpreter.State

  @doc "( n1 n2 -- flag )"
  def smaller_than(%State{} = state) do
    {value1, state} = pop(state)
    {value2, state} = pop(state)
    push(state, to_forth_bool(value2 < value1))
  end

  @doc "( n1 n2 -- flag )"
  def larger_than(%State{} = state) do
    {value1, state} = pop(state)
    {value2, state} = pop(state)
    push(state, to_forth_bool(value2 > value1))
  end

  @doc "( n1 n2 -- flag )"
  def equal(%State{} = state) do
    {value1, state} = pop(state)
    {value2, state} = pop(state)
    push(state, to_forth_bool(value1 == value2))
  end

  @doc "( n1 n2 -- flag )"
  def not_equal(%State{} = state) do
    {value1, state} = pop(state)
    {value2, state} = pop(state)
    push(state, to_forth_bool(value1 != value2))
  end

  @doc "( n1 n2 -- flag )"
  def larger_or_equal(%State{} = state) do
    {value1, state} = pop(state)
    {value2, state} = pop(state)
    push(state, to_forth_bool(value2 >= value1))
  end

  @doc "( n1 n2 -- flag )"
  def smaller_or_equal(%State{} = state) do
    {value1, state} = pop(state)
    {value2, state} = pop(state)
    push(state, to_forth_bool(value2 <= value1))
  end
end
