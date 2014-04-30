defmodule Weather.CLI do

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
      # |> convert_to_hashdict
      # |> print_report
  end

  def decode_response({:ok, body}) do
    IO.inspect(:xmlerl_scan.string(body))
  end

  def decode_response({:error, body}) do
    IO.puts "Error fetching from NOAA: #{body}"
    System.halt(2)
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
