defmodule ControlFlow do
  def string_validator do
    if String.valid?("Hello") do
      "Valid string!"
    else
      "Invalid string."
    end
  end

  def string_truthy do
    if "a string value" do
      "Truthy"
    end
  end

  def unless_integer do
    unless is_integer("hello") do
      "Not an Int"
    end
  end

  def case_match do
    case {:ok, "Hello World"} do
      {:ok, result} -> result
      {:error} -> "Uh oh!"
      _ -> "Catch all"
    end
  end

  def case_even do
    case :even do
      :odd -> "Odd"
      _ -> "Not Odd"
    end
  end

  def cherry_pie do
    pie = 3.14

    case "cherry pie" do
      ^pie -> "Not so tasty"
      pie -> "I bet #{pie} is tasty"
    end
  end

  def case_guard do
    case {1, 2, 3} do
      {1, x, 3} when x > 0 -> "will match"
      _ -> "Won't match"
    end
  end

  def cond_match do
    cond do
      2 + 2 == 5 -> "This will not be true"
      2 * 2 == 3 -> "Nor this"
      1 + 1 == 2 -> "But this will"
    end
  end

  def with_user_name do
    user = %{first: "Sean", last: "Callan"}

    with {:ok, first} <- Map.fetch(user, :first),
         {:ok, last} <- Map.fetch(user, :last) do
      last <> ", " <> first
    end
  end

  def with_else do
    import Integer
    m = %{a: 1, c: 3}

    a =
      with {:ok, res} <- Map.fetch(m, :a),
           true <- is_even(res) do
        IO.puts("Divided by 2 it is #{div(res, 2)}")
        :even
      else
        :error ->
          IO.puts("We don't have this item in map")

        _ ->
          IO.puts("It's odd")
          :odd
      end
  end
end

IO.puts("function: string_validator() returns " <> ControlFlow.string_validator())
IO.puts("function: string_truthy() returns " <> ControlFlow.string_truthy())
IO.puts("function: unless_integer() returns " <> ControlFlow.unless_integer())
IO.puts("function: case_match() returns " <> ControlFlow.case_match())
IO.puts("function: case_even() returns " <> ControlFlow.case_even())
IO.puts("function: cherry_pie() returns " <> ControlFlow.cherry_pie())
IO.puts("function: case_guard() returns " <> ControlFlow.case_guard())
IO.puts("function: cond_match() returns " <> ControlFlow.cond_match())
IO.puts("function: with_user_name() returns " <> ControlFlow.with_user_name())
ControlFlow.with_else()
