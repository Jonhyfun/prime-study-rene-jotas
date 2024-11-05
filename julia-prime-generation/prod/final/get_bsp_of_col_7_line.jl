function find_n(target::BigInt)
  n = 0  # Start from 0 to account for f(0) = 3
  while true
    # Calculate f(n), handling n=0 separately
    result = n == 0 ? 3 : 3 + sum(2^(3 + 2 * (k - 1)) for k in 1:n)

    # Check if the result matches the target
    if result == target
      return n
    elseif result > target
      return nothing  # Return nothing if the target is not in the sequence
    end

    n += 1
  end
end

# Example: Find the n that produces 10923
target_value = parse(BigInt, ARGS[1])
n_result = find_n(target_value)

if n_result !== nothing
  println("The value of n (BSP) for $target_value is $n_result")
else
  println("No integer n produces the target value $target_value")
end