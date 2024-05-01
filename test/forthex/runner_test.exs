defmodule Forthex.RunnerTest do
  use ExUnit.Case

  import ExUnit.CaptureIO

  alias Forthex.Interpreter.State
  alias Forthex.Runner

  @stars_file Path.expand("forth_scripts/stars.forth")

  describe "run/1" do
    test "prints on stdio" do
      input =
        File.read!(@stars_file) <>
          """
          10 \\STARS
          10 /stars
          10 \\StArS2
          """

      expected_output =
        "**********\n **********\n  **********\n   **********\n    **********\n     **********\n      **********\n       **********\n        **********\n         **********\n          **********\n         **********\n        **********\n       **********\n      **********\n     **********\n    **********\n   **********\n  **********\n **********\n**********\n **********\n  **********\n   **********\n    **********\n     **********\n      **********\n       **********\n        **********\n         **********"

      assert capture_io(fn ->
               Runner.run(input)
             end) =~ expected_output
    end
  end

  describe "run/2" do
    test "allows chaining calls" do
      input = """
      : CUSTOM-SQUARE   DUP * ;
      """

      %State{} = state = Runner.run(input)

      assert capture_io(fn ->
               Runner.run("WORDS", state)
             end) =~ "CUSTOM-SQUARE"

      input2 = """
      5 CUSTOM-SQUARE
      """

      %State{stack: stack} = Runner.run(input2, state)
      assert stack == [25]
    end
  end
end
