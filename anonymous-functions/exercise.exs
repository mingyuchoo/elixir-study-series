# list_concat
list_concat = fn (a, b) -> a ++ b end

# sum
sum = fn (a, b, c) -> a + b + c end

# pair_tuple_to_list
pair_tuple_to_list = fn ({a, b}) -> [a, b] end

# fun1
fun1 = fn -> fn -> "Hello" end end
other1 = fun1.()
other1.()

# fun2
fun2 = fn ->
         fn ->
           "Hello"
         end
       end
other2 = fun2.()
other2.()

# fun3
fun3 = fn -> (fn -> "Hello" end) end
other3 = fun3.()
other3.()

# greeter
greeter = fn name -> fn -> "Hello #{name}" end end
dave_greeter = greeter.("Dave")
dave_greeter.()


# add_n
add_n  = fn n -> fn other -> n + other end end
add_two = add_n.(2)
add_five = add_n.(5)
add_two.(3)
add_five.(7)

# prefix
prefix = fn fix -> fn name -> fix <> " " <> name end end
mrs = prefix.("Mrs")
mrs.("Smith")
prefix.("Elixir").("Rocks")


# times_2
times_2 = fn -> n -> n * 2 end
apply = fn (fun, value) -> fun.(value) end
apply.(times_2, 6)

# & notation
add_one = &(&1 + 1)  # add_one = fn n -> n + 1 end
add_one.(44)

square = &(&1 * &1)  # squre = fn n -> n * n end
square.(8)

speak = &(IO.puts(&1)) # speak = fn s -> IO.puts s end
speak.("Hello")
