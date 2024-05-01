defmodule Forthex.LexerTest do
  use ExUnit.Case
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

    test "handles if, else, and then correctly" do
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

    test "handles begin and until correctly" do
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
  end
end
