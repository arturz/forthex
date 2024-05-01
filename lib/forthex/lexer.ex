defmodule Forthex.Lexer do
  @moduledoc false

  alias Forthex.Token

  def tokenize(input) do
    input
    |> String.trim()
    |> String.graphemes()
    |> List.insert_at(-1, " ")
    |> tokenize([])
  end

  defp tokenize([] = _chars, tokens) do
    tokens
    |> List.insert_at(0, Token.new(:eof))
    |> Enum.reverse()
  end

  defp tokenize([char | rest] = chars, tokens) do
    cond do
      whitespace?(char) -> tokenize(rest, tokens)
      comment_start?(char) -> read_comment(chars, tokens)
      print_string_start?(chars) -> read_print_string(chars, tokens)
      word_opening?(chars) -> read_word_opening(chars, tokens)
      word_closing?(char) -> read_word_closing(chars, tokens)
      true -> read_unknown(chars, tokens)
    end
  end

  defp whitespace?(char), do: [" ", "\t", "\n"] |> Enum.member?(char)

  defp comment_start?(char), do: char == "("
  defp comment_end?(char), do: char == ")"

  defp print_string_start?([".", "\"", " " | _rest]), do: true
  defp print_string_start?(_chars), do: false

  defp print_string_end?(char), do: char == "\""

  defp word_opening?([":", " " | _rest]), do: true
  defp word_opening?(_chars), do: false

  defp word_closing?(";"), do: true
  defp word_closing?(_char), do: false

  defp read_comment(["(" | chars], tokens) do
    {comment, [")" | rest]} = Enum.split_while(chars, fn char -> not comment_end?(char) end)

    if comment == [] do
      raise "Missing comment close"
    end

    comment = Enum.join(comment)

    token = Token.new(:comment, comment)
    tokenize(rest, [token | tokens])
  end

  defp read_print_string([".", "\"", " " | chars], tokens) do
    {print_string, ["\"" | rest]} =
      Enum.split_while(chars, fn char -> not print_string_end?(char) end)

    if print_string == [] do
      raise "Missing print string close"
    end

    print_string = Enum.join(print_string)

    token = Token.new(:print_string, print_string)
    tokenize(rest, [token | tokens])
  end

  defp read_word_opening([":", " " | chars], tokens) do
    {word_name, rest} = Enum.split_while(chars, fn char -> not whitespace?(char) end)

    if word_name == [] do
      raise "Missing word name"
    end

    word_name = Enum.join(word_name)

    token = Token.new(:word_opening, word_name)
    tokenize(rest, [token | tokens])
  end

  defp read_word_closing([";" | rest], tokens) do
    token = Token.new(:word_closing)
    tokenize(rest, [token | tokens])
  end

  defp read_unknown(chars, tokens) do
    {unknown, rest} = Enum.split_while(chars, fn char -> not whitespace?(char) end)
    unknown = Enum.join(unknown)

    token =
      case String.downcase(unknown) do
        "if" -> Token.new(:if)
        "else" -> Token.new(:else)
        "then" -> Token.new(:then)
        "begin" -> Token.new(:begin)
        "until" -> Token.new(:until)
        "do" -> Token.new(:do)
        "loop" -> Token.new(:loop)
        _ -> Token.new(:call_or_literal, unknown)
      end

    tokenize(rest, [token | tokens])
  end
end
