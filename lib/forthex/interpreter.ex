defmodule Forthex.Interpreter do
  @moduledoc false

  require Logger

  import Forthex.Interpreter.Dictionary.Helpers

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
        %State{stack: stack, dictionary: dictionary} = state
      ) do
    value = String.downcase(value)

    state =
      if Map.has_key?(dictionary, value) do
        if DictionaryEntry.native?(dictionary[value]) do
          dictionary[value] |> DictionaryEntry.get_reference() |> apply([state])
        else
          dictionary[value] |> DictionaryEntry.get_body() |> interpret(state)
        end
      else
        case Integer.parse(value) do
          {int, ""} ->
            Map.put(state, :stack, [int | stack])

          _ ->
            raise("Not in dictionary and cannot parse to integer: #{inspect(value)}")
            state
        end
      end

    interpret(nodes, state)
  end

  def interpret(
        [%IfExpression{then_body: then_body, else_body: else_body} | nodes],
        state
      ) do
    {value, state} = pop(state)

    state =
      if value != 0 do
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
    Logger.info(value <> " ")
    interpret(nodes, state)
  end

  def interpret(
        [%DoLoop{body: body} | nodes],
        %State{} = state
      ) do
    {from_inclusive, state} = pop(state)
    {to_exclusive, state} = pop(state)

    return_stack =
      case state.return_stack do
        [] -> [-1]
        rest -> [-1 | rest]
      end

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
    return_stack =
      case state.return_stack do
        [] -> [-1]
        rest -> [-1 | rest]
      end

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

        case pop(state) do
          {0, state} -> {:cont, state}
          {_, state} -> {:halt, state}
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
end
