defmodule Forthex.ParserTest do
  use ExUnit.Case
  alias Forthex.Parser

  describe "parse/1" do
    test "works properly" do
      assert Parser.parse([
               %Forthex.Token{type: :word_opening, value: "TEST"},
               %Forthex.Token{type: :call_or_literal, value: "1"},
               %Forthex.Token{type: :call_or_literal, value: "2"},
               %Forthex.Token{type: :call_or_literal, value: "3"},
               %Forthex.Token{type: :word_closing, value: nil},
               %Forthex.Token{type: :word_opening, value: "TEST2"},
               %Forthex.Token{type: :begin, value: nil},
               %Forthex.Token{type: :call_or_literal, value: "-1"},
               %Forthex.Token{type: :until, value: nil},
               %Forthex.Token{type: :word_closing, value: nil},
               %Forthex.Token{type: :call_or_literal, value: "1"},
               %Forthex.Token{type: :if, value: nil},
               %Forthex.Token{type: :call_or_literal, value: "2"},
               %Forthex.Token{type: :print_string, value: "Hello, World!"},
               %Forthex.Token{type: :if, value: nil},
               %Forthex.Token{type: :call_or_literal, value: "3"},
               %Forthex.Token{type: :if, value: nil},
               %Forthex.Token{type: :call_or_literal, value: "-1"},
               %Forthex.Token{type: :else, value: nil},
               %Forthex.Token{type: :call_or_literal, value: "-2"},
               %Forthex.Token{type: :then, value: nil},
               %Forthex.Token{type: :call_or_literal, value: "5"},
               %Forthex.Token{type: :else, value: nil},
               %Forthex.Token{type: :call_or_literal, value: "4"},
               %Forthex.Token{type: :then, value: nil},
               %Forthex.Token{type: :call_or_literal, value: "5"},
               %Forthex.Token{type: :else, value: nil},
               %Forthex.Token{type: :call_or_literal, value: "6"},
               %Forthex.Token{type: :then, value: nil},
               %Forthex.Token{type: :if, value: nil},
               %Forthex.Token{type: :call_or_literal, value: "7"},
               %Forthex.Token{type: :then, value: nil},
               %Forthex.Token{type: :eof, value: nil}
             ]) == %Forthex.Ast.RootNode{
               body: [
                 %Forthex.Ast.WordDefinition{
                   name: "TEST",
                   body: %Forthex.Ast.NodesBlock{
                     body: [
                       %Forthex.Ast.CallOrLiteral{value: "1"},
                       %Forthex.Ast.CallOrLiteral{value: "2"},
                       %Forthex.Ast.CallOrLiteral{value: "3"}
                     ]
                   }
                 },
                 %Forthex.Ast.WordDefinition{
                   name: "TEST2",
                   body: %Forthex.Ast.NodesBlock{
                     body: [
                       %Forthex.Ast.BeginUntilLoop{
                         body: %Forthex.Ast.NodesBlock{
                           body: [%Forthex.Ast.CallOrLiteral{value: "-1"}]
                         }
                       }
                     ]
                   }
                 },
                 %Forthex.Ast.CallOrLiteral{value: "1"},
                 %Forthex.Ast.IfExpression{
                   then_body: %Forthex.Ast.NodesBlock{
                     body: [
                       %Forthex.Ast.CallOrLiteral{value: "2"},
                       %Forthex.Ast.PrintStringExpression{value: "Hello, World!"},
                       %Forthex.Ast.IfExpression{
                         then_body: %Forthex.Ast.NodesBlock{
                           body: [
                             %Forthex.Ast.CallOrLiteral{value: "3"},
                             %Forthex.Ast.IfExpression{
                               then_body: %Forthex.Ast.NodesBlock{
                                 body: [%Forthex.Ast.CallOrLiteral{value: "-1"}]
                               },
                               else_body: %Forthex.Ast.NodesBlock{
                                 body: [%Forthex.Ast.CallOrLiteral{value: "-2"}]
                               }
                             },
                             %Forthex.Ast.CallOrLiteral{value: "5"}
                           ]
                         },
                         else_body: %Forthex.Ast.NodesBlock{
                           body: [%Forthex.Ast.CallOrLiteral{value: "4"}]
                         }
                       },
                       %Forthex.Ast.CallOrLiteral{value: "5"}
                     ]
                   },
                   else_body: %Forthex.Ast.NodesBlock{
                     body: [%Forthex.Ast.CallOrLiteral{value: "6"}]
                   }
                 },
                 %Forthex.Ast.IfExpression{
                   then_body: %Forthex.Ast.NodesBlock{
                     body: [%Forthex.Ast.CallOrLiteral{value: "7"}]
                   },
                   else_body: nil
                 }
               ]
             }
    end
  end
end
