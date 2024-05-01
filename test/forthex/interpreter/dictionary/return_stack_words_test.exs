defmodule Forthex.Interpreter.Dictionary.ReturnStackWordsTest do
  use Forthex.Case

  alias Forthex.Interpreter.Dictionary.ReturnStackWords

  describe "i/1" do
    test "works" do
      state = create_state_with_return_stack([1])
      %State{stack: [value]} = ReturnStackWords.i(state)
      assert value == 1
    end

    test "raises on underflow" do
      state = create_state_with_return_stack([])

      assert_raise(RuntimeError, fn ->
        ReturnStackWords.i(state)
      end)
    end
  end

  describe "j/1" do
    test "works" do
      state = create_state_with_return_stack([1, 2])
      %State{stack: [value]} = ReturnStackWords.j(state)
      assert value == 2
    end

    test "raises on underflow" do
      state = create_state_with_return_stack([1])

      assert_raise(RuntimeError, fn ->
        ReturnStackWords.j(state)
      end)
    end
  end
end
