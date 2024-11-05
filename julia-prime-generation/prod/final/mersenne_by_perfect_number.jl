function possible_prime_for_col(col::BigInt, n::BigInt)
  return col + 12 * (n - 1)
end

# when p is from col 5
function mersenne_line_from_col_7(n::BigInt) # bitshift 10 to the left that will generate the number always ending in 3, that is a very likely mersenne col 7 n (ie: 10923 is the line of mersenne 2^17-1 where 17 is always from col 5)
  return (1 + 2^(12*n-9))÷3
end

function possible_perfect_number_from_col_5(n::BigInt)
  return 2^(possible_prime_for_col(BigInt(5),n)-1) * (2^(possible_prime_for_col(BigInt(5),n))-1)
end

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

function lucas_lehmer(p::BigInt) # TODO entender como funciona o lucas_lehmer e como posso otimizar seguindo a regra das colunas e a base 12
  if p == 2
      return true  # M_2 = 3 is prime
  end

  M_p = 2^p - 1  # Mersenne number M_p
  s = 4  # Initial value for the Lucas-Lehmer sequence

  # Perform the Lucas-Lehmer iterations
  for _ in 1:(p - 2)
      s = (s^2 - 2) % M_p
  end

  return s == 0  # If s == 0, M_p is prime
end

max_n = parse(BigInt, ARGS[1])

for n in 1:max_n
  mersenne_line =  mersenne_line_from_col_7(n)
  possible_perfect_number = possible_perfect_number_from_col_5(n)
  possible_prime = possible_prime_for_col(BigInt(7),mersenne_line)
  mersenne_p_5 = possible_prime_for_col(BigInt(5),n) # a mersenne from col 5 will generate a col 7 mersenne prime that the p always ends with 3 (3 bitshift of 10 to the left)
  
  if is_perfect_number(possible_perfect_number)
    if possible_perfect_number == possible_prime * 2^(mersenne_p_5-1) 
      println("$(n)")
    end
  end
end