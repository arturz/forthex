defmodule Forthex.Ast.PrintStringExpression do
  @moduledoc false

  @enforce_keys [:value]
  defstruct [:value]

  alias Forthex.Ast.Node

  defimpl Node do
    def to_string(print_string_expression) do
      ".\"" <> print_string_expression.value <> "\""
    end
  end

  def new(print_string_expression) do
    %__MODULE__{value: print_string_expression}
  end
end
