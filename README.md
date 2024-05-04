# Forthex

This is a simple [FORTH](https://www.forth.com/forth/) stack-based programming language interpreter written in Elixir.

# Getting started

Forthex contains a mix task for interpreting Forth script files and a basic REPL (Read-Eval-Print Loop).

Create a file `fibonacci.forth` inside the Forthex directory with an example content:

```forth
: FIBONACCI ( i -- n_1..n_i )
  0 1 ROT 0 DO
    2DUP
    +
  LOOP .s ;

10 FIBONACCI
```

When you run `mix x fibonacci.forth`, it calculates and prints 10 first Fibonacci sequence numbers.

In the same fashion, you can run `mix x` to start a simple REPL and provide all words and commands by hand.

# Supported syntax

- loops:
  - `DO ... LOOP`
  - `BEGIN ... UNTIL`
- conditionals:
  - `IF ... THEN`
  - `IF ... ELSE ... THEN`
- comments: `( this is a comment )`
- words (functions) declaration: `: SQUARE   DUP * ;`
- standard output prints: `." Hello world!"`

# Supported words

- stack words: `.`, `.s`, `DUP`, `DROP`, `SWAP`, `OVER`, `ROT`, `2DUP`, `2DROP`, `2SWAP`, `2OVER`, `CLEAR`
- math operators: `+`, `-`, `*`, `/`, `ABS`
- logic operators: `<`, `>`, `=`, `<>`, `<=`, `>=`, `AND`, `OR`
- IO operations: `EMIT`, `SPACES`, `ACCEPT` (reads a number and pushes onto the stack)
- return stack operations: `i` (loop index), `j` (outer loop index)
- miscellaneous operations: `RANDOM`, `WORDS`

# Technical details

Forthex consists of three parts: lexer, parser and interpreter.

## Lexer

Given a source code:

```forth
: LARGER-THAN-10?
    10 >
    IF ." Larger than 10"
    ELSE ." Smaller than 10 or equal"
    THEN ;
```

lexer returns a list of tokens:

```elixir
[
  %Forthex.Token{type: :word_opening, value: "LARGER-THAN-10?"},
  %Forthex.Token{type: :call_or_literal, value: "10"},
  %Forthex.Token{type: :call_or_literal, value: ">"},
  %Forthex.Token{type: :if, value: nil},
  %Forthex.Token{type: :print_string, value: "Larger than 10"},
  %Forthex.Token{type: :else, value: nil},
  %Forthex.Token{type: :print_string, value: "Smaller than 10 or equal"},
  %Forthex.Token{type: :then, value: nil},
  %Forthex.Token{type: :word_closing, value: nil},
  %Forthex.Token{type: :eof, value: nil}
]
```

During this process, basic syntax rules are enforced.

## Parser

The parser receives a list of tokens and builds an Abstract Syntax Tree that looks like this:

```elixir
%Forthex.Ast.RootNode{
  body: [
    %Forthex.Ast.WordDefinition{
      name: "LARGER-THAN-10?",
      body: %Forthex.Ast.NodesBlock{
        body: [
          %Forthex.Ast.CallOrLiteral{value: "10"},
          %Forthex.Ast.CallOrLiteral{value: ">"},
          %Forthex.Ast.IfExpression{
            then_body: %Forthex.Ast.NodesBlock{
              body: [
                %Forthex.Ast.PrintStringExpression{value: "Larger than 10"}
              ]
            },
            else_body: %Forthex.Ast.NodesBlock{
              body: [
                %Forthex.Ast.PrintStringExpression{
                  value: "Smaller than 10 or equal"
                }
              ]
            }
          }
        ]
      }
    }
  ]
}
```

AST building blocks are named nodes, here is a brief overview of a few of them:

- `RootNode` - as the name suggests, a starting point for all other nodes
- `NodesBlock` - container for nested nodes
- `BeginUntilLoop` and `DoLoop` - contain blocks evaluated on each loop iteration
- `IfExpression` - contains a block that is evaluated when a truthy value lies on top of the stack and an optional block that is evaluated otherwise

A full list is available under the namespace `Forthex.Ast`. Every node also implements the `Node` protocol for serialization and debugging purposes.

## Interpreter

The interpreter creates an initial state with predefined words and walks through the AST, evaluating each node according to its type and rules of the FORTH language.
