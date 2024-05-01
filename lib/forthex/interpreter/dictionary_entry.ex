defmodule Forthex.Interpreter.DictionaryEntry do
  @moduledoc false
  defstruct [:body_or_reference, :type]

  def new(body) do
    %__MODULE__{body_or_reference: body, type: :compiled}
  end

  def new_native(reference) do
    %__MODULE__{body_or_reference: reference, type: :native}
  end

  def get_body(%__MODULE__{body_or_reference: body}), do: body
  def get_reference(arg), do: get_body(arg)

  def native?(%__MODULE__{type: :native}), do: true
  def native?(_), do: false
end
