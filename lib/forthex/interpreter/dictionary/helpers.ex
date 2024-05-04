defmodule Forthex.Interpreter.Dictionary.Helpers do
  @moduledoc false

  alias Forthex.Interpreter.State

  def push(%State{stack: stack} = state, value) do
    Map.put(state, :stack, [value | stack])
  end

  def pop(%State{stack: [value | stack]} = state) do
    {value, Map.put(state, :stack, stack)}
  end

  def pop(%State{stack: []} = state) do
    raise_stack_underflow()
    state
  end

  def raise_stack_underflow do
    raise("Stack underflow!")
  end

  def raise_return_stack_underflow do
    raise("Return stack underflow!")
  end
end
