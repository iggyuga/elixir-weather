defmodule Weather.Worker do
	
	def temperature_of(location, temperature_option) do
		result = url_for(location) 
			|> HTTPoison.get 
			|> parse_response(temperature_option)
		case result do
			{:ok, temp} ->
				"#{location}: #{temp}*#{String.capitalize(temperature_option)}"
			:error ->
				"#{location} not found"
		end
	end

	def loop() do
		receive do
			{sender_pid, location, temperature_option} ->
				send(sender_pid, {:ok, temperature_of(location, temperature_option)})
			_ ->
				IO.puts("don't know what todo here")
			end
		loop()
	end

	defp url_for(location) do
		location = URI.encode(location)
		"http://api.openweathermap.org/data/2.5/weather?q=#{location}&appid=#{apikey()}"
	end

	defp parse_response({:ok, %HTTPoison.Response{body: body, status_code: 200}}, option) do
		body 
		|> JSON.decode! 
		|> computer_temperature(option)
	end

	defp parse_response(_, _) do
		:error
	end

	defp computer_temperature(json, option) do
		try do
			temp = convert(json["main"]["temp"], option) |> Float.round(2)
			{:ok, temp}
		rescue
			_ -> :error
		end
	end

	defp apikey() do
		"8536c81ebcb074abbe45452b799dec42"
	end

	defp convert(temperature, option) do
		cond do 
			option in ["f", "F"] -> 
				temperature * (9/5) - 459.67
			option in ["c", "C"] ->
				temperature - 273.15
			true ->
				temperature
		end
	end

end
