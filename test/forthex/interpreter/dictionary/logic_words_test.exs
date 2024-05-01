defmodule Forthex.Interpreter.Dictionary.LogicWordsTest do
  use Forthex.Case

  alias Forthex.Interpreter.Dictionary.LogicWords

  test "smaller_than/1" do
    assert_puts_true_on_stack([2, 1], &LogicWords.smaller_than/1)
    assert_puts_false_on_stack([1, 2], &LogicWords.smaller_than/1)
  end

  test "larger_than/1" do
    assert_puts_true_on_stack([1, 2], &LogicWords.larger_than/1)
    assert_puts_false_on_stack([2, 1], &LogicWords.larger_than/1)
  end

  test "equal/1" do
    assert_puts_true_on_stack([1, 1], &LogicWords.equal/1)
    assert_puts_false_on_stack([1, 2], &LogicWords.equal/1)
  end

  test "not_equal/1" do
    assert_puts_true_on_stack([1, 2], &LogicWords.not_equal/1)
    assert_puts_false_on_stack([1, 1], &LogicWords.not_equal/1)
  end

  test "larger_or_equal/1" do
    assert_puts_true_on_stack([1, 1], &LogicWords.larger_or_equal/1)
    assert_puts_true_on_stack([1, 2], &LogicWords.larger_or_equal/1)
    assert_puts_false_on_stack([2, 1], &LogicWords.larger_or_equal/1)
  end

  test "smaller_or_equal/1" do
    assert_puts_true_on_stack([1, 1], &LogicWords.smaller_or_equal/1)
    assert_puts_true_on_stack([2, 1], &LogicWords.smaller_or_equal/1)
    assert_puts_false_on_stack([1, 2], &LogicWords.smaller_or_equal/1)
  end
end
