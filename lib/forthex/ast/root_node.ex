defmodule Forthex.Ast.RootNode do
  @moduledoc false

  alias Forthex.Ast.Node

  defstruct [:body]

  defimpl Node do
    def to_string(nodes_block) do
      nodes_block
      |> Map.fetch!(:body)
      |> Enum.map_join("\n", &Node.to_string/1)
    end
  end

  def new(body) do
    %__MODULE__{body: body}
  end
end
