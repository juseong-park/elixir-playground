# Functional |> Concurrent |> Pragmatic |> Fun

handle_open = fn
  {:ok, file} -> "First line: #{IO.read(file, :line)}"
  {_, error} -> "Error: #{:file.format_error(error)}"
end

IO.puts(handle_open.(File.open("main.ex")))
IO.puts(handle_open.(File.open("invalid")))

times_2 = fn n -> n * 2 end
apply = fn fun, val -> fun.(val) end

IO.puts(apply.(times_2, 5))

list = [1, 2, 3, 4, 5]
Enum.map(list, fn elem -> elem * 2 end)

defmodule Greeter do
  def for(name, greeting) do
    fn
      ^name -> "#{greeting} #{name}"
      _ -> "I don't know you"
    end
  end
end

hello = Greeter.for("Park", "Hello")

IO.puts(hello.("Park"))
IO.puts(hello.("Kim"))

add_one = &(&1 + 1)
IO.puts(add_one.(30))

square = &(&1 * &1)
IO.puts(square.(8))

speak = &IO.puts(&1)
IO.puts(speak.("Hello World"))

div_rem = &{div(&1, &2), rem(&1, &2)}

bacon = &"Bacon and #{&1}"
IO.puts(bacon.("Egg"))

Enum.map([1, 2, 3, 4], &(&1 * &1))

defmodule Times do
  def double(n) do
    n * 2
  end

  def triple(n), do: n * 3
end

IO.puts(Times.double(3))
IO.puts(Times.triple(3))

defmodule Factorial do
  def of(0), do: 1

  def of(n) when is_integer(n) and n > 0 do
    n * of(n - 1)
  end
end

IO.puts(Factorial.of(10))

defmodule Gcd do
  def of(x, 0), do: x
  def of(x, y), do: of(y, rem(x, y))
end

IO.puts(Gcd.of(10, 2))

defmodule Guard do
  def what_is(x) when is_number(x) do
    IO.puts("#{x} is a number")
  end

  def what_is(x) when is_list(x) do
    IO.puts("#{inspect(x)} is a list")
  end

  def what_is(x) when is_atom(x) do
    IO.puts("#{inspect(x)} is a atom")
  end
end

Guard.what_is(20)
Guard.what_is([1, 2, 3, 4, 5])
Guard.what_is(:apple)

pipes =
  1..10
  |> Enum.map(&(&1 * &1))
  |> Enum.filter(&(&1 < 30))

IO.inspect(pipes)

defmodule MyList do
  def len([]), do: 0
  def len([_ | tail]), do: 1 + len(tail)
  def square([]), do: []
  def square([head | tail]), do: [head * head | square(tail)]
  def map([], _func), do: []
  def map([head | tail], func), do: [func.(head) | map(tail, func)]
  def reduce([], value, _), do: value
  def reduce([head | tail], value, func), do: reduce(tail, func.(head, value), func)
  def span(x, x), do: [x]
  def span(from, to) when from < to, do: [from | span(from + 1, to)]
end

IO.puts(MyList.len([1, 2, 3, 4, 5, 10]))
IO.inspect(MyList.square([1, 2, 3, 4]))
IO.inspect(MyList.map([1, 2, 3, 4], fn n -> n * n end))
IO.inspect(Enum.map([1, 2, 3, 4], fn n -> n * n end))
IO.inspect(MyList.reduce([1, 2, 3, 4], 0, &(&1 + &2)))
IO.inspect(MyList.reduce([1, 2, 3, 4], 0, fn a, b -> a + b end))
IO.inspect(MyList.span(1, 10))

defmodule WeatherHistory do
  def for_location(_, []), do: []

  def for_location(location, [head = [_, location, _, _] | tail]) do
    [head | for_location(location, tail)]
  end

  def for_location(location, [_ | tail]), do: for_location(location, tail)
end

WeatherHistory.for_location(27, [
  [1234, 26, 15, 0.125],
  [1234, 27, 15, 0.115],
  [5555, 27, 15, 0.011],
  [5555, 23, 17, 0.011],
  [1555, 27, 9, 1.5]
])
|> List.flatten()
|> IO.inspect()

person = %{name: "Dave", height: 180}

IO.inspect(%{name: a_name} = person)
IO.inspect(%{name: _, height: _} = person)
IO.inspect(%{name: "Dave"} = person)

people = [
  %{name: "Park", height: 175},
  %{name: "Kim", height: 180},
  %{name: "Lee", height: 170},
  %{name: "Kyle", height: 185}
]

IO.inspect(for person = %{height: height} <- people, height >= 180, do: person)

data = %{name: "Dave", state: "TX", likes: "Elixir"}

for key <- [:name, :likes] do
  %{^key => value} = data
  IO.puts(value)
end

m1 = %{a: 1, b: 2, c: 3}
m2 = %{m1 | b: 20}
IO.inspect(m1)
IO.inspect(m2)

defmodule Subscriber do
  defstruct name: "", paid: false, adult: true
end

nested = %{
  buttercup: %{
    actor: %{
      first: "Robin",
      last: "Wright"
    },
    role: "pricess"
  },
  westley: %{
    actor: %{
      first: "Cary",
      last: "Elwis"
    },
    role: "farm boy"
  }
}

IO.inspect(get_in(nested, [:buttercup, :actor]))
IO.inspect(put_in(nested, [:westley, :actor, :last], "Elwes"))

set1 = 1..10 |> Enum.into(MapSet.new())
set2 = 5..15 |> Enum.into(MapSet.new())

IO.inspect(set1)
IO.inspect(set2)
IO.inspect(MapSet.member?(set1, 5))
IO.inspect(MapSet.union(set1, set2))
IO.inspect(MapSet.difference(set1, set2))
IO.inspect(MapSet.intersection(set1, set2))

defmodule TailRecursive do
  def factorial(n), do: _fact(n, 1)
  defp _fact(0, acc), do: acc
  defp _fact(n, acc), do: _fact(n - 1, acc * n)
end

IO.puts(TailRecursive.factorial(5))

IO.inspect(Enum.to_list(1..5))
IO.inspect(Enum.concat([1, 2, 3], [4, 5, 6]))
IO.inspect(Enum.concat([1, 2, 3], ~c"abc"))
IO.inspect(Enum.map([1, 2, 3, 4], &String.duplicate("*", &1)))
IO.puts(Enum.at(100..200, 3))

IO.inspect(for x <- [1, 2, 3, 4, 5], do: x * x)
