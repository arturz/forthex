defmodule Forthex.Interpreter.Dictionary.StackWords do
  @moduledoc false

  import Forthex.Interpreter.Dictionary.Helpers

  alias Forthex.Interpreter.State

  @doc "( x -- )"
  def dot(%State{} = state) do
    {value, state} = pop(state)
    IO.write(inspect(value) <> " ")
    state
  end

  @doc "( -- )"
  def dot_s(%State{} = state) do
    State.print_stack(state)
    state
  end

  @doc "( x -- x x )"
  def dup(%State{} = old_state) do
    {value, _state} = pop(old_state)
    push(old_state, value)
  end

  @doc "( x1 x2 -- x1 x2 x1 x2 )"
  def two_dup(%State{} = old_state) do
    {value2, state} = pop(old_state)
    {value1, _state} = pop(state)

    old_state
    |> push(value1)
    |> push(value2)
  end

  @doc "( x -- )"
  def drop(%State{} = state) do
    {_value, state} = pop(state)
    state
  end

  @doc "( x1 x2 -- )"
  def two_drop(%State{} = state) do
    state
    |> drop()
    |> drop()
  end

  @doc "( x1 x2 -- x2 x1 )"
  def swap(%State{} = state) do
    {value2, state} = pop(state)
    {value1, state} = pop(state)

    state
    |> push(value2)
    |> push(value1)
  end

  @doc "( x1 x2 x3 x4 -- x3 x4 x1 x2 )"
  def two_swap(%State{} = state) do
    {value4, state} = pop(state)
    {value3, state} = pop(state)
    {value2, state} = pop(state)
    {value1, state} = pop(state)

    state
    |> push(value3)
    |> push(value4)
    |> push(value1)
    |> push(value2)
  end

  @doc "( x1 x2 -- x1 x2 x1 )"
  def over(%State{} = old_state) do
    {value2, state} = pop(old_state)
    {value1, state} = pop(state)

    state
    |> push(value1)
    |> push(value2)
    |> push(value1)
  end

  @doc "( x1 x2 x3 x4 -- x1 x2 x3 x4 x1 x2)"
  def two_over(%State{} = old_state) do
    {_value4, state} = pop(old_state)
    {_value3, state} = pop(state)
    {value2, state} = pop(state)
    {value1, _state} = pop(state)

    old_state
    |> push(value1)
    |> push(value2)
  end

  @doc "( x1 x2 x3 -- x2 x3 x1 )"
  def rot(%State{} = state) do
    {value3, state} = pop(state)
    {value2, state} = pop(state)
    {value1, state} = pop(state)

    state
    |> push(value2)
    |> push(value3)
    |> push(value1)
  end

  def clear(%State{} = state) do
    Map.put(state, :stack, [])
  end
end
