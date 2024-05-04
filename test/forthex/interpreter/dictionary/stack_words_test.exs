defmodule Forthex.Interpreter.Dictionary.StackWordsTest do
  use Forthex.Case

  alias Forthex.Interpreter.Dictionary.StackWords

  test "dot/1" do
    assert capture_io(fn ->
             assert_stack_transformation([123], [], &StackWords.dot/1)
           end) =~ "123"
  end

  test "dot_s/1" do
    assert capture_log(fn ->
             create_state_with_stack([1, 2, 3]) |> StackWords.dot_s()
           end) =~ "<3, 2, 1>"
  end

  test "dup/1" do
    assert_stack_transformation([1], [1, 1], &StackWords.dup/1)
  end

  test "two_dup/1" do
    assert_stack_transformation([1, 2], [1, 2, 1, 2], &StackWords.two_dup/1)
  end

  test "drop/1" do
    assert_stack_transformation([1], [], &StackWords.drop/1)
  end

  test "two_drop/1" do
    assert_stack_transformation([1, 2], [], &StackWords.two_drop/1)
  end

  test "swap/1" do
    assert_stack_transformation([1, 2], [2, 1], &StackWords.swap/1)
  end

  test "two_swap/1" do
    assert_stack_transformation([1, 2, 3, 4], [3, 4, 1, 2], &StackWords.two_swap/1)
  end

  test "over/1" do
    assert_stack_transformation([1, 2], [2, 1, 2], &StackWords.over/1)
  end

  test "two_over/1" do
    assert_stack_transformation([1, 2, 3, 4], [3, 4, 1, 2, 3, 4], &StackWords.two_over/1)
  end

  test "rot/1" do
    assert_stack_transformation([1, 2, 3], [3, 1, 2], &StackWords.rot/1)
  end

  test "clear/1" do
    assert_stack_transformation([1, 2, 3], [], &StackWords.clear/1)
  end
end
