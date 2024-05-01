defmodule Forthex.Interpreter.Dictionary.MathWordsTest do
  use Forthex.Case

  alias Forthex.Interpreter.Dictionary.MathWords

  test "plus/1" do
    assert_stack_transformation([1, 2], [3], &MathWords.plus/1)
  end

  test "minus/1" do
    assert_stack_transformation([1, 2], [1], &MathWords.minus/1)
  end

  test "multiply/1" do
    assert_stack_transformation([2, 3], [6], &MathWords.multiply/1)
  end

  test "divide/1" do
    assert_stack_transformation([3, 6], [2], &MathWords.divide/1)
  end
end
