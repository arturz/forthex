defmodule Forthex.Interpreter.Dictionary.MiscellaneousWordsTest do
  use Forthex.Case

  alias Forthex.Interpreter.Dictionary.MiscellaneousWords
  alias Forthex.Runner

  test "words/1" do
    state =
      Runner.run("""
      : some-example-word   1 ;
      """)

    assert capture_io(fn ->
             MiscellaneousWords.words(state)
           end) =~ "SOME-EXAMPLE-WORD"
  end

  describe "random/1" do
    test "works with absolute numbers" do
      from_inclusive = 1
      to_inclusive = 2
      state = create_state_with_stack([from_inclusive, to_inclusive])

      assert 1..10_000
             |> Enum.reduce(%{}, fn _, acc ->
               %State{stack: [value]} = MiscellaneousWords.random(state)
               Map.put(acc, value, true)
             end) == %{1 => true, 2 => true}
    end

    test "works with negative numbers" do
      state = create_state_with_stack([-11, -10])

      %State{stack: [value]} = MiscellaneousWords.random(state)
      assert value == -10 or value == -11
    end
  end
end
