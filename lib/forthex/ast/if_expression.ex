defmodule Forthex.Ast.IfExpression do
  @moduledoc false

  @enforce_keys [:then_body]
  defstruct [:then_body, :else_body]

  alias Forthex.Ast.Node

  defimpl Node do
    def to_string(if_node) do
      %{then_body: then_body, else_body: else_body} = if_node

      if else_body == nil do
        "if #{Node.to_string(then_body)} then"
      else
        "if #{Node.to_string(then_body)} else #{Node.to_string(else_body)} then"
      end
    end
  end

  def new(then_body, else_body \\ nil) do
    %__MODULE__{then_body: then_body, else_body: else_body}
  end
end
