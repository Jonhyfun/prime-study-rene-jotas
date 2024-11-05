using Base.Threads
# 1 + 12 * (n-1) = 12n - 11
# 5 + 12 * (n-1) = 12n - 7
# 7 + 12 * (n-1) = 12n - 5
# 11 + 12 * (n-1) = 12n - 1

prime_parents = [1, 5, 7, 11]
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


function find_valid_n_m_pairs(max_n::BigInt)
  # Specify the type for valid_pairs as a vector of tuples
  valid_pairs = Vector{Tuple{Int, Int}}() 
  skipped_ms = Set{Int}()  # Use a Set for efficient membership testing
  lock_skipped_ms = ReentrantLock()  # Lock for thread-safe access

  # Parallelize over the outer loop using @threads
  @threads for m in 1:max_n

      derived_prime_factors = Vector{Tuple{BigInt, BigInt}}()

      # Initialize derived_prime_factors
      push!(derived_prime_factors, (1, 5))
      push!(derived_prime_factors, (1, 7))
      push!(derived_prime_factors, (7, 11))
      push!(derived_prime_factors, (6, 13))

      possible_prime_col_5 = 12 * m - prime_parents_subtractor[5]

      if possible_prime_col_5 == 1
          continue
      end

      sqrt_prime_col_5 = floor(Int, sqrt(possible_prime_col_5))

      should_skip_m = false  # Flag to track if m should be skipped

      previous_factor = nothing

      for n in 1:sqrt_prime_col_5
          skip = false
          
          # Check if n satisfies the derived prime factor conditions
          previous_factor = nothing
          for derivedPrimeFactorIndex in eachindex(derived_prime_factors)
              if derived_prime_factors[derivedPrimeFactorIndex][2] > sqrt_prime_col_5
                continue
              end
              
              if ((n - derived_prime_factors[derivedPrimeFactorIndex][1]) % derived_prime_factors[derivedPrimeFactorIndex][2]) == 0
                  skip = true
                  previous_factor = derived_prime_factors[derivedPrimeFactorIndex]
                  break
              end
          end
          
          if skip
              continue
          end

          # Check skipped_ms for m before proceeding
          lock(lock_skipped_ms) do
              if m in skipped_ms
                  should_skip_m = true
              end
          end

          if should_skip_m
              break  # Break the n loop if m is in skipped_ms
          end

          # Loop through prime parents
          for parentIndex in eachindex(prime_parents)
              for i in 1:1000
                possible_prime_other_col = 12 * n - prime_parents_subtractor[prime_parents[parentIndex]]

                if possible_prime_other_col == 1 || possible_prime_other_col == possible_prime_col_5
                    continue
                end

                # Check if n is a divisor of possible_prime_col_5
                if possible_prime_col_5 == 77 
                  print("$(possible_prime_col_5), $(possible_prime_other_col)")
                end
                if (possible_prime_col_5 % possible_prime_other_col) == 0
                    lock(lock_skipped_ms) do
                        push!(skipped_ms, m)  # Ensure thread-safe modification
                    end

                    # Call to find_n_formula should return a suitable tuple
                    #println(possible_prime_other_col)
                    derived_n_formula = find_n_formula(BigInt(possible_prime_other_col))
                    #println(derived_prime_factors)
                    #println(derived_n_formula, n)
                    
                    if !(derived_n_formula in derived_prime_factors) #! não faz sentido esse if ser necessário (talvez seja só uma race condition...)
                      push!(derived_prime_factors, derived_n_formula)
                    end

                    lock(lock_skipped_ms) do
                        push!(valid_pairs, (n, m))  # Store valid pairs
                        should_skip_m = true
                    end
                    println("$(possible_prime_col_5) - $(m), $(n) of $(prime_parents[parentIndex])")
                    break  # Break out of parentIndex loop
                end
              end
          end

          if should_skip_m
              break  # Break the n loop if m is now marked for skipping
          end
      end
  end

  return valid_pairs
end

max_n = BigInt(100)

start_time = time()

find_valid_n_m_pairs(max_n)

end_time = time()

# Get the valid (n, m) pairs

# Print the results
#println("Valid (m, n, prime_parent) pairs:")
#for pair in valid_n_m_pairs
#  println(pair)
#end

println("Estimated Time: $(end_time - start_time) seconds")