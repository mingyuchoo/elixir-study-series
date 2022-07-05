case File.open("exception") do
  { :ok, file } -> IO.puts "First line: #{IO.read(file, :line)}"
  { :error, message } -> raise "Failed to open config file: #{message}"
end
