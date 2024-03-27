x = 1
# 1
{x, ^x} = {2, 1}
# {2, 1}
IO.puts(x)
# x

key = "hello"
# "hello"
%{^key => value} = %{"hello" => "world"}
# %{"hello" => "world"}
IO.puts(value)
# "world"

greeting = "Hello"
# "Hello"
greet = fn
  ^greeting, name -> "Hi #{name}"
  greeting, name -> "#{greeting}, #{name}"
end

IO.puts(greet.("Hello", "Choo"))
# "Hi Choo"
IO.puts(greet.("Monrin'", "Choo"))
# "Mornin', Choo"
IO.puts(greeting)
# "Hello"
