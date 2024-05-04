defmodule Forthex.InterpreterTest do
  use Forthex.Case

  alias Forthex.Interpreter
  alias Forthex.Interpreter.State
  alias Forthex.Lexer
  alias Forthex.Parser

  describe "interpret/2 - WordDefinition" do
    test "compiles word into the dictionary" do
      %State{dictionary: dictionary} =
        """
        : TEST   1 2 + ;
        """
        |> get_ast()
        |> Interpreter.interpret()

      assert "test" in Map.keys(dictionary)
    end
  end

  describe "interpret/2 - CallOrLiteral" do
    test "pushes literals onto the stack" do
      %State{stack: [3, 2, 1]} =
        """
        1 2 3
        """
        |> get_ast()
        |> Interpreter.interpret()
    end

    test "calls compiled word from the dictionary" do
      %State{stack: [3]} =
        """
        : TEST   1 2 + ;

        TEST
        """
        |> get_ast()
        |> Interpreter.interpret()
    end

    test "calls native word from the dictionary" do
      %State{stack: [1, 3, 2]} =
        """
        1 2 3 ROT
        """
        |> get_ast()
        |> Interpreter.interpret()
    end

    test "raises on invalid literal" do
      ["1.0", "asdf"]
      |> Enum.each(fn literal ->
        assert_raise(RuntimeError, fn ->
          literal
          |> get_ast()
          |> Interpreter.interpret()
        end)
      end)
    end
  end

  describe "interpret/2 - IfExpression" do
    test "properly interprets IF ... THEN conditional" do
      %State{stack: [1]} =
        """
        : IF-THEN-TEST   0 = IF 1 THEN ;

        -1 IF-THEN-TEST
        0 IF-THEN-TEST
        1 IF-THEN-TEST
        """
        |> get_ast()
        |> Interpreter.interpret()
    end

    test "properly interprets IF ... ELSE ... THEN conditional" do
      %State{stack: [0, 1, 0]} =
        """
        : IF-ELSE-THEN-TEST   0 = IF 1 ELSE 0 THEN ;

        -1 IF-ELSE-THEN-TEST
        0 IF-ELSE-THEN-TEST
        1 IF-ELSE-THEN-TEST
        """
        |> get_ast()
        |> Interpreter.interpret()
    end

    test "properly interprets nested conditionals" do
      ast =
        """
        : SPELLER   DUP 0 < IF ." NEGATIVE " THEN
          ABS DUP 0 = IF ." ZERO" ELSE
          DUP 1 = IF ." ONE" ELSE
          DUP 2 = IF ." TWO" ELSE
          DUP 3 = IF ." THREE" ELSE
          DUP 4 = IF ." FOUR"
          THEN THEN THEN THEN THEN DROP ;

        : TEST
          6 -5 DO
            I SPELLER
          LOOP ;

        TEST
        """
        |> get_ast()

      assert capture_io(fn -> Interpreter.interpret(ast) end) ==
               [
                 "NEGATIVE ",
                 "NEGATIVE FOUR",
                 "NEGATIVE THREE",
                 "NEGATIVE TWO",
                 "NEGATIVE ONE",
                 "ZERO",
                 "ONE",
                 "TWO",
                 "THREE",
                 "FOUR"
               ]
               |> Enum.join("")
    end
  end

  describe "interpret/2 - PrintStringExpression" do
    test "properly interprets print string expression" do
      ast =
        """
        ." Hello, world!"
        """
        |> get_ast()

      assert capture_io(fn -> Interpreter.interpret(ast) end) == "Hello, world!"
    end
  end

  describe "interpret/2 - DoLoop" do
    test "properly interprets negative indices" do
      ast =
        """
        5 -5 DO
          I .
        LOOP
        """
        |> get_ast()

      assert capture_io(fn -> Interpreter.interpret(ast) end) == "-5 -4 -3 -2 -1 0 1 2 3 4 "
    end

    test "properly interprets nested DO ... LOOP loops" do
      ast =
        """
        11 1 DO
          11 1 DO
            I J * .
          LOOP
          CR
        LOOP
        """
        |> get_ast()

      assert capture_io(fn -> Interpreter.interpret(ast) end) == """
             1 2 3 4 5 6 7 8 9 10\s
             2 4 6 8 10 12 14 16 18 20\s
             3 6 9 12 15 18 21 24 27 30\s
             4 8 12 16 20 24 28 32 36 40\s
             5 10 15 20 25 30 35 40 45 50\s
             6 12 18 24 30 36 42 48 54 60\s
             7 14 21 28 35 42 49 56 63 70\s
             8 16 24 32 40 48 56 64 72 80\s
             9 18 27 36 45 54 63 72 81 90\s
             10 20 30 40 50 60 70 80 90 100\s
             """
    end

    test "raises on invalid indices" do
      assert_raise(RuntimeError, fn ->
        """
        1 1 DO I LOOP
        """
        |> get_ast()
        |> Interpreter.interpret()
      end)

      assert_raise(RuntimeError, fn ->
        """
        1 2 DO I LOOP
        """
        |> get_ast()
        |> Interpreter.interpret()
      end)
    end
  end

  describe "interpret/2 - BeginUntilLoop" do
    test "properly interprets nested BEGIN ... UNTIL loops" do
      ast =
        """
        BEGIN
          BEGIN
            I 1 + J 1 + * .
            I 8 >
          UNTIL
          CR
          I 8 >
        UNTIL
        """
        |> get_ast()

      assert capture_io(fn -> Interpreter.interpret(ast) end) == """
             1 2 3 4 5 6 7 8 9 10\s
             2 4 6 8 10 12 14 16 18 20\s
             3 6 9 12 15 18 21 24 27 30\s
             4 8 12 16 20 24 28 32 36 40\s
             5 10 15 20 25 30 35 40 45 50\s
             6 12 18 24 30 36 42 48 54 60\s
             7 14 21 28 35 42 49 56 63 70\s
             8 16 24 32 40 48 56 64 72 80\s
             9 18 27 36 45 54 63 72 81 90\s
             10 20 30 40 50 60 70 80 90 100\s
             """
    end
  end

  defp get_ast(source_code) do
    source_code
    |> Lexer.tokenize()
    |> Parser.parse()
  end
end
