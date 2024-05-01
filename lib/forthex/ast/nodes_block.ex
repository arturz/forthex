defmodule Forthex.Ast.NodesBlock do
  @moduledoc false

  alias Forthex.Ast.Node

  defstruct [:body]

  defimpl Node do
    def to_string(nodes_block) do
      nodes_block
      |> Map.fetch!(:body)
      |> Enum.map_join(" ", &Node.to_string/1)
    end
  end

  defimpl Enumerable do
    def count(nodes_block) do
      Enumerable.count(nodes_block.body)
    end

    def member?(nodes_block, value) do
      Enumerable.member?(nodes_block.body, value)
    end

    def reduce(nodes_block, acc, fun) do
      Enumerable.reduce(nodes_block.body, acc, fun)
    end

    def slice(nodes_block) do
      Enumerable.slice(nodes_block.body)
    end
  end

  def new(body) do
    %__MODULE__{body: body}
  end
end
