defmodule Weather.CLI do

  require Record

  defrecord :xmlElement,
            Record.extract(:xmlElement, from_lib: "xmerl/include/xmerl.hrl")
  defrecord :xmlText,
            Record.extract(:xmlText, from_lib: "xmerl/include/xmerl.hrl")

  def main(argv) do
    run(argv)
  end

  def run(argv) do
    argv
      |> parse_args
      |> process
  end

  def process(:help) do
    IO.puts "Usage:  weather <abbreviation>"
    System.halt(0)
  end

  def process(abbr) do
    Weather.NOAA.fetch(abbr)
      |> decode_response
      |> valid_root_element
      |> print_fields([
           "observation_time",
           "weather",
           "temp_f",
           "dewpoint_f",
           "relative_humidity",
           "wind_string",
           "windchill_f",
           "visibility_mi"
         ])
  end

  def decode_response({:ok, body}) do
    {element, _rest} = :xmerl_scan.string(to_char_list(body))
    element
  end

  def decode_response({:error, body}) do
    IO.puts "Non-200 response code when fetching from NOAA."
    System.halt(2)
  end

  def valid_root_element(element) do
    case element do
      :xmlElement[name: :current_observation]
        -> element
      _ ->
        IO.puts "Invalid root element!"
        System.halt(2)
    end
  end

  def print_fields(element, fields) do
    Enum.each(fields, &print_value(&1, element))
  end

  def print_value(field, element) do
    [ text ] = :xmerl_xpath.string(field_xpath(field), element)
    IO.puts "#{field}: #{text.value}"
  end

  def field_xpath(field) do
    to_char_list("/current_observation/#{field}/text()")
  end

  def convert_to_hashdict(element) do
    [ pickup ] = :xmerl_xpath.string('/current_observation/suggested_pickup', element)
    [ text ] = pickup.content
    IO.inspect(text.value)
  end

  def parse_args(argv) do
    parse = OptionParser.parse(argv, switches: [ help: :boolean ],
                                     aliases:  [ h:    :help ])
    case parse do

      { [ help: true ], _, _ } -> :help
      { _, [ abbr ], _ } -> abbr
      _ -> :help
    end
  end

end
