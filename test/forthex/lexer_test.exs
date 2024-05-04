defmodule Forthex.LexerTest do
  use Forthex.Case

  alias Forthex.Lexer
  alias Forthex.Token

  describe "tokenize/1" do
    test "returns a list of tokens" do
      assert Lexer.tokenize("1 2 +") == [
               %Token{type: :call_or_literal, value: "1"},
               %Token{type: :call_or_literal, value: "2"},
               %Token{type: :call_or_literal, value: "+"},
               %Token{type: :eof}
             ]
    end

    test "handles whitespace correctly" do
      assert Lexer.tokenize("""
               1\t2
             +
             """) == [
               %Token{type: :call_or_literal, value: "1"},
               %Token{type: :call_or_literal, value: "2"},
               %Token{type: :call_or_literal, value: "+"},
               %Token{type: :eof}
             ]
    end

    test "handles comments correctly" do
      assert Lexer.tokenize("(this is some comment) 1 2 +") == [
               %Token{type: :comment, value: "this is some comment"},
               %Token{type: :call_or_literal, value: "1"},
               %Token{type: :call_or_literal, value: "2"},
               %Token{type: :call_or_literal, value: "+"},
               %Token{type: :eof}
             ]
    end

    test "handles print strings correctly" do
      assert Lexer.tokenize(".\" Hello, World!\" 1 2 +") == [
               %Token{type: :print_string, value: "Hello, World!"},
               %Token{type: :call_or_literal, value: "1"},
               %Token{type: :call_or_literal, value: "2"},
               %Token{type: :call_or_literal, value: "+"},
               %Token{type: :eof}
             ]
    end

    test "handles word openings and closings correctly" do
      assert Lexer.tokenize(": square   dup * ; 5 square") == [
               %Token{type: :word_opening, value: "square"},
               %Token{type: :call_or_literal, value: "dup"},
               %Token{type: :call_or_literal, value: "*"},
               %Token{type: :word_closing},
               %Token{type: :call_or_literal, value: "5"},
               %Token{type: :call_or_literal, value: "square"},
               %Token{type: :eof}
             ]
    end

    test "handles IF ... ELSE ... THEN correctly" do
      assert Lexer.tokenize("1 2 if dup else drop then") == [
               %Token{type: :call_or_literal, value: "1"},
               %Token{type: :call_or_literal, value: "2"},
               %Token{type: :if},
               %Token{type: :call_or_literal, value: "dup"},
               %Token{type: :else},
               %Token{type: :call_or_literal, value: "drop"},
               %Token{type: :then},
               %Token{type: :eof}
             ]
    end

    test "handles BEGIN ... UNTIL loop correctly" do
      assert Lexer.tokenize("begin 1 dup 2 < until") == [
               %Token{type: :begin},
               %Token{type: :call_or_literal, value: "1"},
               %Token{type: :call_or_literal, value: "dup"},
               %Token{type: :call_or_literal, value: "2"},
               %Token{type: :call_or_literal, value: "<"},
               %Token{type: :until},
               %Token{type: :eof}
             ]
    end

    test "handles DO ... LOOP loop correctly" do
      assert Lexer.tokenize("5 0 do i . loop") == [
               %Token{type: :call_or_literal, value: "5"},
               %Token{type: :call_or_literal, value: "0"},
               %Token{type: :do},
               %Token{type: :call_or_literal, value: "i"},
               %Token{type: :call_or_literal, value: "."},
               %Token{type: :loop},
               %Token{type: :eof}
             ]
    end

    test "raises on missing word name" do
      assert_raise(RuntimeError, fn ->
        Lexer.tokenize(":   dup * ; 5 square")
      end)
    end

    test "raises on missing print string close" do
      assert_raise(RuntimeError, fn ->
        Lexer.tokenize(".\" Hello, World! 1 2 +")
      end)
    end

    test "raises on missing comment close" do
      assert_raise(RuntimeError, fn ->
        Lexer.tokenize("(this is some comment 1 2 +")
      end)
    end
  end
end
