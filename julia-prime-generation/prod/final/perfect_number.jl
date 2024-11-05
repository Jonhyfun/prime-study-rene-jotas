function is_perfect_number(n::BigInt)
  if n % 2 != 0
    return false
  end

  sum_divisors = 1  # 1 is always a divisor, but exclude `n`
  sqrt_n = floor(BigInt, sqrt(n))

  # Loop over divisors up to √n
  for i in 2:2:sqrt_n
      if n % i == 0
          sum_divisors += i
          if i != n ÷ i  # Add the corresponding divisor pair, avoiding adding sqrt(n) twice
              sum_divisors += n ÷ i
          end
      end
      
      # Early exit if the sum exceeds the number
      if sum_divisors > n
          return false
      end
  end
  
  return sum_divisors == n
end

println(is_perfect_number(parse(BigInt, ARGS[1])))