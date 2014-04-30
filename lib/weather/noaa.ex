defmodule Weather.NOAA do

  alias HTTPotion.Response

  @user_agent [ "User-Agent": "Elixir ernie@erniemiller.org"]

  def fetch(abbr) do
    case HTTPotion.get(noaa_url(abbr), @user_agent) do
      Response[body: body, status_code: status, headers: _headers]
      when status in 200..299 ->
        { :ok, body }
      Response[body: body, status_code: _status, headers: _headers] ->
        { :error, body }
    end
  end

  def noaa_url(abbr) do
    "http://w1.weather.gov/xml/current_obs/#{abbr}.xml"
  end

end

