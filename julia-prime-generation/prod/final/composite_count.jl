# Function to check if a number is prime
function is_prime(n::BigInt)
  if n <= 1
      return false
  elseif n == 2
      return true
  elseif n % 2 == 0
      return false
  end
  for i in 3:2:sqrt(n)
      if n % i == 0
          return false
      end
  end
  return true
end

# Function to find the odd prime factors of a number
function find_odd_prime_factors(n::BigInt)
  prime_factors = []
  divisor = 3
  while divisor * divisor <= n
      if n % divisor == 0
          push!(prime_factors, divisor)
          while n % divisor == 0
              n ÷= divisor
          end
      end
      divisor += 2
  end
  if n > 1
      push!(prime_factors, n)  # n itself is prime
  end
  return prime_factors
end

# Function to check if n has more than one composite factor aside from powers of 2
function has_more_than_one_composite_factor(n::BigInt)
  # Step 1: Divide out all powers of 2
  while n % 2 == 0
      n ÷= 2
  end

  # Step 2: Check prime factorization of the remaining odd number
  prime_factors = find_odd_prime_factors(n)
  return length(prime_factors) == 1  # More than one prime factor means multiple composites
end

# Example usage
n = BigInt(8584564574574579869056)
result = has_more_than_one_composite_factor(n)

if result
  println("$(n) has more than one composite factor besides 2.")
else
  println("$(n) does not have exactly one composite factor besides 2.")
end