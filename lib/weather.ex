defmodule Weather do
  @moduledoc """
  Documentation for Weather.
  """

  @doc """
  Hello world.

  ## Examples

      iex> Weather.hello
      :world

  """
  def temperatures_of(cities) do
    IO.puts("Hi")
    coordinator_pid = 
      spawn(Weather.Coordinator, :loop, [[], Enum.count(cities)])

    cities |> Enum.each(fn city ->
      worker_pid = spawn(Weather.Worker, :loop, [])
      send(worker_pid, {coordinator_pid, city})
    end)
  end
end