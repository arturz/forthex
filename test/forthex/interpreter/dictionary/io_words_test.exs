defmodule Forthex.Interpreter.Dictionary.IoWordsTest do
  use Forthex.Case

  alias Forthex.Interpreter.Dictionary.IOWords

  test "cr/1" do
    assert capture_io(fn ->
             IOWords.cr(State.new())
           end) =~ "\n"
  end

  test "emit/1" do
    assert capture_io(fn ->
             [65] |> create_state_with_stack() |> IOWords.emit()
           end) =~ "A"
  end

  test "spaces/1" do
    assert capture_io(fn ->
             [5] |> create_state_with_stack() |> IOWords.spaces()
           end) =~ "     "
  end

  test "accept/1" do
    assert capture_io([input: "123"], fn ->
             %State{stack: stack} = IOWords.accept(State.new())
             assert stack == [123]
           end)
  end
end
