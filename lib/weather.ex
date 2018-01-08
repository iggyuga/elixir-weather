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
  def temperatures_of(cities, temperature_option) do
    IO.puts("Hi")
    coordinator_pid = 
      spawn(Weather.Coordinator, :loop, [[], Enum.count(cities)])

    cities |> Enum.each(fn city ->
      worker_pid = spawn(Weather.Worker, :loop, [])
      send(worker_pid, {coordinator_pid, city, temperature_option})
    end)
  end

  
	defp url_for(location) do
		location = URI.encode(location)
		"http://api.openweathermap.org/data/2.5/weather?q=#{location}&appid=#{apikey()}"
	end
end