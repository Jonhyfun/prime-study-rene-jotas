using Base.Threads
# 1 + 12 * (n-1) = 12n - 11
# 5 + 12 * (n-1) = 12n - 7
# 7 + 12 * (n-1) = 12n - 5
# 11 + 12 * (n-1) = 12n - 1

prime_parents = [BigInt(1), BigInt(5), BigInt(7), BigInt(11)]
prime_parents_subtractor = Dict(1 => 11, 5 => 7, 7 => 5, 11 => 1)

primes_col_5 = Vector{BigInt}()
skipped_ms = Vector{BigInt}()

# Function to find all valid pairs (n, m)

const n_formula_cache = Dict{BigInt, Tuple{BigInt, BigInt}}()

function find_n_formula(divisor::BigInt)
  # Check if the result is already cached
  if haskey(n_formula_cache, divisor)
      return n_formula_cache[divisor]  # Return the cached result
  end

  # Coefficients in the equation
  a = 12 % divisor    # Coefficient of (n - 1)
  c = (-5 % divisor + divisor) % divisor  # The right-hand side

  # To find n: a(n - 1) ≡ c (mod divisor)

  # Find the modular inverse of a mod divisor
  function mod_inverse(a, m)
      for x in 1:m
          if (a * x) % m == 1
              return x
          end
      end
      error("Inverse does not exist")
  end

  # Get the inverse of a
  inverse_a = mod_inverse(a, divisor)

  # Calculate n - 1
  n_minus_1 = (c * inverse_a) % divisor

  # n = n_minus_1 + 1
  result = (n_minus_1 + 1, divisor)

  # Cache the computed result
  n_formula_cache[divisor] = result

  return result
end

function get_possible_prime_from_col(col::BigInt, line::BigInt)
  return (12*line) - (prime_parents_subtractor[col])
end

function find_ceiling_n(col::BigInt, possible_prime::BigInt) #? the greatest N that returns a number smaller than the possible_prime
  # Solve for n: 5 + 12(n - 1) < max_value
  n = floor(((possible_prime - col)/12) + 1)
  return BigInt(n)
end


function check_prime(possible_prime::BigInt)
  for parentIndex in eachindex(prime_parents)
    primeParent = prime_parents[parentIndex]
    primeSquare = BigInt(floor(Int, sqrt(possible_prime)))

    ceiling_for_square = find_ceiling_n(primeParent, primeSquare)
    
    for n in 1:ceiling_for_square
      possible_prime_other_col = get_possible_prime_from_col(primeParent, n)
      if possible_prime % possible_prime_other_col == 0
        println("$(possible_prime) is divisible by $(possible_prime_other_col)")
      end
    end
  end

  println("$(possible_prime) is divisible by $(possible_prime)")
end

max_n = BigInt(100)

start_time = time()

#find_valid_n_m_pairs(max_n)

check_prime(parse(BigInt, ARGS[1]))

end_time = time()

# Get the valid (n, m) pairs

# Print the results
#println("Valid (m, n, prime_parent) pairs:")
#for pair in valid_n_m_pairs
#  println(pair)
#end

println("Estimated Time: $(end_time - start_time) seconds")