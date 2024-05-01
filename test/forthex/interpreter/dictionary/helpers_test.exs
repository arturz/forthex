defmodule Forthex.Interpreter.Dictionary.HelpersTest do
  use Forthex.Case

  alias Forthex.Interpreter.Dictionary.Helpers

  test "push/1" do
    state = create_state_with_stack([1])
    %State{stack: stack} = Helpers.push(state, 2)
    assert stack == [2, 1]
  end

  describe "pop/1" do
    test "works" do
      state = create_state_with_stack([1, 2])
      {popped_value, %State{stack: stack}} = Helpers.pop(state)
      assert popped_value == 1
      assert stack == [2]
    end

    test "raises on underflow" do
      state = create_state_with_stack([])

      assert_raise(RuntimeError, fn ->
        Helpers.pop(state)
      end)
    end
  end
end
