defmodule Forthex.Case do
  @moduledoc false

  defmacro __using__(_opts) do
    quote do
      use ExUnit.Case, async: true

      import ExUnit.CaptureIO
      import ExUnit.CaptureLog

      import Forthex.Utils.LogicUtils

      alias Forthex.Interpreter.State

      def create_state_with_stack(stack) do
        State.new() |> Map.put(:stack, stack)
      end

      def create_state_with_return_stack(return_stack) do
        State.new() |> Map.put(:return_stack, return_stack)
      end

      def assert_stack_transformation(from, to, function) when is_list(from) and is_list(to) do
        state = create_state_with_stack(from)

        new_state = function.(state)

        assert new_state.stack == to
      end

      def assert_puts_true_on_stack(stack, function) do
        state = create_state_with_stack(stack)
        %State{stack: [value]} = function.(state)
        assert truthy?(value)
      end

      def assert_puts_false_on_stack(stack, function) do
        state = create_state_with_stack(stack)
        %State{stack: [value]} = function.(state)
        assert falsy?(value)
      end
    end
  end
end
