defmodule Forthex.Parser do
  @moduledoc false

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

  def parse(tokens) do
    do_parse(tokens, [])
  end

  def do_parse([], ast), do: ast

  def do_parse([%{type: :eof} = token | tokens], ast) do
    parse_eof(token, tokens, ast)
  end

  def do_parse([%{type: :call_or_literal} = token | tokens], ast) do
    parse_call_or_literal(token, tokens, ast)
  end

  def do_parse([%{type: :print_string} = token | tokens], ast) do
    parse_print_string(token, tokens, ast)
  end

  def do_parse([%{type: :word_opening} = token | tokens], ast) do
    parse_word_opening(token, tokens, ast)
  end

  def do_parse([%{type: :begin} = token | tokens], ast) do
    parse_begin_loop_opening(token, tokens, ast)
  end

  def do_parse([%{type: :do} = token | tokens], ast) do
    parse_do_loop_opening(token, tokens, ast)
  end

  def do_parse([%{type: :if} = token | tokens], ast) do
    parse_if_opening(token, tokens, ast)
  end

  def do_parse([%{type: :else} = token | tokens], ast) do
    parse_else(token, tokens, ast)
  end

  def do_parse([%{type: :comment} = _token | tokens], ast) do
    do_parse(tokens, ast)
  end

  def do_parse([%{type: type} = token | tokens], ast) do
    if Enum.member?([:word_closing, :until, :loop, :then], type) do
      parse_block_end(token, tokens, ast)
    else
      raise "Unknown token type: #{inspect(token)}"
    end
  end

  defp parse_eof(_token, _tokens, ast) do
    ast
    |> Enum.reverse()
    |> RootNode.new()
  end

  defp parse_call_or_literal(token, tokens, ast) do
    node = CallOrLiteral.new(token.value)
    do_parse(tokens, [node | ast])
  end

  defp parse_print_string(token, tokens, ast) do
    node = PrintStringExpression.new(token.value)
    do_parse(tokens, [node | ast])
  end

  defp parse_word_opening(token, tokens, ast) do
    case do_parse(tokens, []) do
      %{body: body, tokens_rest: tokens_rest} ->
        node = WordDefinition.new(token.value, body)
        do_parse(tokens_rest, [node | ast])

      _ ->
        raise "Invalid word definition"
    end
  end

  defp parse_begin_loop_opening(_token, tokens, ast) do
    case do_parse(tokens, []) do
      %{body: body, tokens_rest: tokens_rest} ->
        node = BeginUntilLoop.new(body)
        do_parse(tokens_rest, [node | ast])

      _ ->
        raise "Invalid BEGIN ... UNTIL loop"
    end
  end

  defp parse_do_loop_opening(_token, tokens, ast) do
    case do_parse(tokens, []) do
      %{body: body, tokens_rest: tokens_rest} ->
        node = DoLoop.new(body)
        do_parse(tokens_rest, [node | ast])

      _ ->
        raise "Invalid DO ... LOOP loop"
    end
  end

  defp parse_if_opening(_token, tokens, ast) do
    case do_parse(tokens, []) do
      %{body: body, tokens_rest: tokens_rest} ->
        node = IfExpression.new(body)
        do_parse(tokens_rest, [node | ast])

      %{body_before_else: body_before_else, tokens_rest: tokens_rest} ->
        case do_parse(tokens_rest, []) do
          %{body: body, tokens_rest: tokens_rest} ->
            node = IfExpression.new(body_before_else, body)
            do_parse(tokens_rest, [node | ast])

          _ ->
            raise "Invalid IF ... ELSE ... THEN conditional"
        end

      _ ->
        raise "Invalid IF ... THEN conditional"
    end
  end

  defp parse_block_end(_token, tokens, ast) do
    %{
      body: ast |> Enum.reverse() |> NodesBlock.new(),
      tokens_rest: tokens
    }
  end

  defp parse_else(_token, tokens, ast) do
    %{
      body_before_else: ast |> Enum.reverse() |> NodesBlock.new(),
      tokens_rest: tokens
    }
  end
end
