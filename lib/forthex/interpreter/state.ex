defmodule Forthex.Interpreter.State do
  @moduledoc false

  require Logger
  alias Forthex.Interpreter.DictionaryEntry

  alias Forthex.Interpreter.Dictionary.{
    IOWords,
    LogicWords,
    MathWords,
    MiscellaneousWords,
    ReturnStackWords,
    StackWords
  }

  @enforce_keys [:stack, :return_stack, :dictionary]
  defstruct [:stack, :return_stack, :dictionary]

  def new do
    dictionary = %{
      "." => DictionaryEntry.new_native(&StackWords.dot/1),
      ".s" => DictionaryEntry.new_native(&StackWords.dot_s/1),
      "dup" => DictionaryEntry.new_native(&StackWords.dup/1),
      "2dup" => DictionaryEntry.new_native(&StackWords.two_dup/1),
      "drop" => DictionaryEntry.new_native(&StackWords.drop/1),
      "2drop" => DictionaryEntry.new_native(&StackWords.two_drop/1),
      "swap" => DictionaryEntry.new_native(&StackWords.swap/1),
      "2swap" => DictionaryEntry.new_native(&StackWords.two_swap/1),
      "over" => DictionaryEntry.new_native(&StackWords.over/1),
      "2over" => DictionaryEntry.new_native(&StackWords.two_over/1),
      "rot" => DictionaryEntry.new_native(&StackWords.rot/1),
      "clear" => DictionaryEntry.new_native(&StackWords.clear/1),
      "i" => DictionaryEntry.new_native(&ReturnStackWords.i/1),
      "j" => DictionaryEntry.new_native(&ReturnStackWords.j/1),
      "+" => DictionaryEntry.new_native(&MathWords.plus/1),
      "-" => DictionaryEntry.new_native(&MathWords.minus/1),
      "*" => DictionaryEntry.new_native(&MathWords.multiply/1),
      "/" => DictionaryEntry.new_native(&MathWords.divide/1),
      "abs" => DictionaryEntry.new_native(&MathWords.absolute/1),
      ">" => DictionaryEntry.new_native(&LogicWords.larger_than/1),
      "<" => DictionaryEntry.new_native(&LogicWords.smaller_than/1),
      "=" => DictionaryEntry.new_native(&LogicWords.equal/1),
      "<>" => DictionaryEntry.new_native(&LogicWords.not_equal/1),
      ">=" => DictionaryEntry.new_native(&LogicWords.larger_or_equal/1),
      "<=" => DictionaryEntry.new_native(&LogicWords.smaller_or_equal/1),
      "and" => DictionaryEntry.new_native(&LogicWords.forth_and/1),
      "or" => DictionaryEntry.new_native(&LogicWords.forth_or/1),
      "cr" => DictionaryEntry.new_native(&IOWords.cr/1),
      "emit" => DictionaryEntry.new_native(&IOWords.emit/1),
      "spaces" => DictionaryEntry.new_native(&IOWords.spaces/1),
      "accept" => DictionaryEntry.new_native(&IOWords.accept/1),
      "random" => DictionaryEntry.new_native(&MiscellaneousWords.random/1),
      "words" => DictionaryEntry.new_native(&MiscellaneousWords.words/1)
    }

    %__MODULE__{stack: [], return_stack: [], dictionary: dictionary}
  end

  def print_stack(%__MODULE__{stack: stack} = state) do
    if stack == [] do
      Logger.info("Stack: <empty>")
    else
      Logger.info("Stack: <" <> (stack |> Enum.reverse() |> Enum.join(", ")) <> ">")
    end

    state
  end
end
