defmodule Forthex.Ast.WordDefinition do
  @moduledoc false

  alias Forthex.Ast.Node

  defstruct [:name, :body]

  defimpl Node do
    def to_string(word_definition) do
      %{name: name, body: body} = word_definition

      ": #{name}   #{Node.to_string(body)} ;"
    end
  end

  def new(name, body) do
    %__MODULE__{name: name, body: body}
  end
end
