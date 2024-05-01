defmodule Forthex.Ast.BeginUntilLoop do
  @moduledoc false

  alias Forthex.Ast.Node

  defstruct [:body]

  defimpl Node do
    def to_string(begin_until_loop) do
      "BEGIN #{begin_until_loop |> Map.fetch!(:body) |> Enum.map(&Node.to_string/1)} UNTIL"
    end
  end

  def new(body) do
    %__MODULE__{body: body}
  end
end
