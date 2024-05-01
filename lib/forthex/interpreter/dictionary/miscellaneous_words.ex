defmodule Forthex.Interpreter.Dictionary.MiscellaneousWords do
  @moduledoc false

  import Forthex.Interpreter.Dictionary.Helpers

  alias Forthex.Interpreter.State

  @doc "( -- )"
  def words(%State{dictionary: dictionary} = state) do
    IO.write("\n Words: ")

    dictionary
    |> Map.keys()
    |> Enum.map(&String.upcase/1)
    |> Enum.sort()
    |> Enum.join(" ")
    |> IO.puts()

    state
  end

  @doc "( n1 n2 -- n3 )"
  def random(%State{} = state) do
    {to_inclusive, state} = pop(state)
    {from_inclusive, state} = pop(state)
    value = Enum.random(from_inclusive..to_inclusive)
    push(state, value)
  end
end
