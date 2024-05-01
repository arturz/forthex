defmodule Forthex.Ast.CallOrLiteral do
  @moduledoc false

  @enforce_keys [:value]
  defstruct [:value]

  alias Forthex.Ast.Node

  defimpl Node do
    def to_string(call_or_literal) do
      call_or_literal.value
    end
  end

  def new(call_or_literal) do
    %__MODULE__{value: call_or_literal}
  end
end
