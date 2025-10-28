# Integers

IO.puts "Integers ----------------------"
Enum.each([255, 0b0110, 0o644, 0x1F],
  fn (x) -> IO.puts "#{x} is integer #{is_integer(x)}" end)

# Floats

IO.puts "Floats ------------------------"
Enum.each([3.14, 1.0e-10],
  fn (x) -> IO.puts "#{x} is float #{is_float(x)}" end)

# Booleans
IO.puts "Booleans ----------------------"
Enum.each([true, false],
  fn (x) -> IO.puts "#{x} is boolean #{is_boolean(x)}" end)

# Atoms

IO.puts "Atoms -------------------------"
Enum.each([true, false, :true, :false],
  fn (x) -> IO.puts "#{x} is a atom #{is_atom(x)}" end)
IO.puts "MyApp.MyModule is a atom #{is_atom(MyApp.MyModule)}"

# Strings
IO.puts "Strings ----------------------"
Enum.each(["Hello", "dziękuję"],
  fn (x) -> IO.puts "#{x}(byte size: #{byte_size(x)}, length: #{String.length(x)}) is binary #{is_binary(x)}" end)
