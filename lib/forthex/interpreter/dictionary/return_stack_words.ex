defmodule Forthex.Interpreter.Dictionary.ReturnStackWords do
  @moduledoc false

  import Forthex.Interpreter.Dictionary.Helpers

  alias Forthex.Interpreter.State

  def i(%State{return_stack: return_stack} = state) do
    value = Enum.at(return_stack, 0)

    if value == nil do
      raise_return_stack_underflow()
    end

    push(state, value)
  end

  def j(%State{return_stack: return_stack} = state) do
    value = Enum.at(return_stack, 1)

    if value == nil do
      raise_return_stack_underflow()
    end

    push(state, value)
  end
end
