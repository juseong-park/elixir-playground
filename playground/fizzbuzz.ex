defmodule Solution do
  def fizzbuzzList(n), do: 1..n |> Enum.map(&fizzbuzz/1)
  def fizzbuzz(n), do: _func(n, rem(n, 3), rem(n, 5))

  defp _func(_n, 0, 0), do: "FizzBuzz"
  defp _func(_n, 0, _), do: "Fizz"
  defp _func(_n, _, 0), do: "Buzz"
  defp _func(n, _, _), do: "#{n}"
end

IO.puts(Solution.fizzbuzz(15))
IO.puts(Solution.fizzbuzz(12))
IO.puts(Solution.fizzbuzz(10))

IO.inspect(Solution.fizzbuzzList(15))
