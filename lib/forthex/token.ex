defmodule Forthex.Token do
  @moduledoc false

  @enforce_keys [:type]
  defstruct [:type, :value]

  @available_types [
    :word_opening,
    :word_closing,
    :comment,
    :print_string,
    :call_or_literal,
    :if,
    :else,
    :then,
    :begin,
    :until,
    :do,
    :loop,
    :eof
  ]

  def new(type, value \\ nil) do
    if Enum.member?(@available_types, type) do
      %Forthex.Token{type: type, value: value}
    else
      raise "Invalid token type: #{inspect(type)}"
    end
  end
end
