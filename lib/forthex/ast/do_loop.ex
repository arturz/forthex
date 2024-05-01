defmodule Forthex.Ast.DoLoop do
  @moduledoc false

  alias Forthex.Ast.Node

  defstruct [:body]

  defimpl Node do
    def to_string(begin_until_loop) do
      "DO #{begin_until_loop |> Map.fetch!(:body) |> Enum.map(&Node.to_string/1)} LOOP"
    end
  end

  def new(body) do
    %__MODULE__{body: body}
  end
end
