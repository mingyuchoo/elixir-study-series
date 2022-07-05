user_file_name = "error.ex" # "exception.ex"

case File.open(user_file_name) do
  { :ok, file } -> IO.puts "First line: #{IO.read(file, :line)}"
  { :error, message } -> IO.puts :stderr, "Couldn't open #{user_file_name}: #{message}"
end
