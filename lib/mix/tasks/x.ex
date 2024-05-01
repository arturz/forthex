defmodule Mix.Tasks.X do
  @moduledoc false

  use Mix.Task

  require Logger

  alias Forthex.Runner

  @shortdoc "Executes optional FORTH file passed as argument and starts REPL."
  def run([]) do
    repl(Runner.run(""))
  end

  def run([arg | _args]) do
    arg
    |> Path.expand()
    |> File.read!()
    |> Runner.run()
    |> repl()
  end

  defp repl(state) do
    case IO.read(:line) do
      :eof ->
        repl(state)

      {:error, error} ->
        Logger.error("Error while reading input: #{inspect(error)}")

      data ->
        state =
          try do
            Runner.run(data, state)
          rescue
            e in RuntimeError ->
              Logger.error(e.message)
              state

            e ->
              Logger.error("Invalid input (#{inspect(e)})")
              state
          end

        repl(state)
    end
  end
end
