defmodule Forthex.Utils.LogicUtils do
  @moduledoc false

  @spec to_forth_bool(boolean()) :: 0 | 1
  def to_forth_bool(false), do: 0
  def to_forth_bool(true), do: 1

  @spec falsy?(integer()) :: boolean()
  def falsy?(0), do: true
  def falsy?(_value), do: false

  @spec truthy?(integer()) :: boolean()
  def truthy?(value), do: not falsy?(value)
end
