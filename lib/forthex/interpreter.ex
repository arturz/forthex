defmodule Forthex.Interpreter do
  @moduledoc false

  require Logger

  import Forthex.Interpreter.Dictionary.Helpers
  import Forthex.Utils.LogicUtils

  alias Forthex.Interpreter.DictionaryEntry

  alias Forthex.Ast.{
    BeginUntilLoop,
    CallOrLiteral,
    DoLoop,
    IfExpression,
    NodesBlock,
    PrintStringExpression,
    RootNode,
    WordDefinition
  }

  alias Forthex.Interpreter.State

  def interpret(%RootNode{} = root_node) do
    interpret(root_node, State.new())
  end

  def interpret(%RootNode{body: body}, state) do
    interpret(body, state)
  end

  def interpret(%NodesBlock{body: body}, state) do
    interpret(body, state)
  end

  def interpret(
        [%WordDefinition{body: body, name: name} | nodes],
        %State{dictionary: dictionary} = state
      ) do
    name = String.downcase(name)
    state = Map.put(state, :dictionary, Map.put(dictionary, name, DictionaryEntry.new(body)))
    interpret(nodes, state)
  end

  def interpret(
        [%CallOrLiteral{value: value} | nodes],
        %State{dictionary: dictionary} = state
      ) do
    value = String.downcase(value)

    state =
      if Map.has_key?(dictionary, value) do
        interpret_word_call(state, value)
      else
        interpret_literal(state, value)
      end

    interpret(nodes, state)
  end

  def interpret(
        [%IfExpression{then_body: then_body, else_body: else_body} | nodes],
        state
      ) do
    {value, state} = pop(state)

    state =
      if truthy?(value) do
        interpret(then_body, state)
      else
        interpret(else_body, state)
      end

    interpret(nodes, state)
  end

  def interpret(
        [%PrintStringExpression{value: value} | nodes],
        state
      ) do
    IO.write(value)
    interpret(nodes, state)
  end

  def interpret(
        [%DoLoop{body: body} | nodes],
        %State{} = state
      ) do
    {from_inclusive, state} = pop(state)
    {to_exclusive, state} = pop(state)

    if from_inclusive >= to_exclusive do
      raise("In '( n1 n2 -- ... ) DO ... LOOP' n1 must be greater than n2")
    end

    return_stack = [from_inclusive - 1 | state.return_stack]

    state = Map.put(state, :return_stack, return_stack)

    state =
      Range.new(from_inclusive, to_exclusive - 1)
      |> Enum.reduce(state, fn _i, state ->
        [value | rest] = state.return_stack
        return_stack = [value + 1 | rest]

        state = Map.put(state, :return_stack, return_stack)

        interpret(body, state)
      end)

    [_value | return_stack_rest] = state.return_stack
    state = Map.put(state, :return_stack, return_stack_rest)

    interpret(nodes, state)
  end

  def interpret(
        [%BeginUntilLoop{body: body} | nodes],
        %State{} = state
      ) do
    return_stack = [-1 | state.return_stack]

    state = Map.put(state, :return_stack, return_stack)

    state =
      Enum.reduce_while(1..10_000, state, fn i, state ->
        if i == 10_000 do
          raise("Infinite loop detected")
        end

        [value | rest] = state.return_stack
        return_stack = [value + 1 | rest]

        state = Map.put(state, :return_stack, return_stack)

        state = interpret(body, state)

        {value, state} = pop(state)

        if truthy?(value) do
          {:halt, state}
        else
          {:cont, state}
        end
      end)

    [_value | return_stack_rest] = state.return_stack
    state = Map.put(state, :return_stack, return_stack_rest)

    interpret(nodes, state)
  end

  def interpret([], state) do
    state
  end

  def interpret(nil, state) do
    state
  end

  defp interpret_word_call(%State{dictionary: dictionary} = state, word_name) do
    if DictionaryEntry.native?(dictionary[word_name]) do
      dictionary[word_name] |> DictionaryEntry.get_reference() |> apply([state])
    else
      dictionary[word_name] |> DictionaryEntry.get_body() |> interpret(state)
    end
  end

  def interpret_literal(%State{stack: stack} = state, value) do
    case Integer.parse(value) do
      {int, ""} ->
        Map.put(state, :stack, [int | stack])

      _ ->
        raise("Cannot parse to integer: #{inspect(value)}")
        state
    end
  end
end
