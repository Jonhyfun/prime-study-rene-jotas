using Base.Threads
using Base.Math

# Correct the initialization of the vector to allow for flexible integer types like Int or BigInt
prime_parents = [1, 5, 7, 11]
prime_parents_subtractor = Dict(1 => 11, 5 => 7, 7 => 5, 11 => 1)

primes_col_5 = Vector{Int}()
skipped_ms = Vector{Int}()

function derived_ns_for_divisor(divisor::T) where {T<:Integer}
  a = 12 % divisor
  c = (-5 % divisor + divisor) % divisor

  function mod_inverse(a, m::T) where {T<:Integer}
    for x in T(1):m
      if (a * x) % m == 1
        return x
      end
    end
    error("Inverse does not exist")
  end

  inverse_a = mod_inverse(a, divisor)
  n_minus_1 = (c * inverse_a) % divisor
  n = n_minus_1 + 1

  if divisor == 7 && n % 7 == 0
    result = (T(0), divisor)
  else
    result = (n, divisor)
  end

  return result
end

function get_possible_prime_from_col(col, line)
  T = promote_type(line)
  return T(12 * line) - T(prime_parents_subtractor[col])
end

function find_ceiling_n(col, possible_prime::T) where {T<:Integer}
  n = floor(((possible_prime - col) / 12) + 1)
  return T(n)
end

const skips = Set{Tuple{BigInt,BigInt}}()
const possible_primes = Set{BigInt}()
const confirmed_non_primes = Set{BigInt}()

push!(skips, (1, 5))
push!(skips, (0, 7))
push!(skips, (7, 11))
push!(skips, (6, 13))

function check_prime(possible_prime::T, possible_prime_n::T) where {T<:Integer}
  found_not_prime = false
  for parentIndex in eachindex(prime_parents)
    found_not_prime = false
    primeParent = prime_parents[parentIndex]
    primeSquare = T(floor(Int, sqrt(T(possible_prime))))

    ceiling_for_square = find_ceiling_n(primeParent, primeSquare)

    for n in 1:ceiling_for_square
      for (n_subtractor, divisor) in skips
        if possible_prime_n - n_subtractor > 1 && (possible_prime_n - n_subtractor) % divisor == 0
          found_not_prime = true
          break
        end
      end

      if found_not_prime == true
        push!(confirmed_non_primes, possible_prime)
        break
      else
        possible_prime_other_col = get_possible_prime_from_col(primeParent, n)
        if possible_prime_other_col != 1
          if possible_prime % possible_prime_other_col == 0
            #println("($(possible_prime_n)) $(possible_prime) is divisible by $(possible_prime_other_col)")
            new_divisor = derived_ns_for_divisor(possible_prime_other_col)
            push!(skips, new_divisor)
            push!(confirmed_non_primes, possible_prime)
            found_not_prime = true
            break
          end
        end
      end
    end

    if found_not_prime == true
      found_not_prime = false
      break
    end
  end

  if found_not_prime == false
    #println("($(possible_prime_n)) $(possible_prime) is divisible by $(possible_prime)")
  end
  #println()
end

function promote_type(x)
  if x isa BigInt
    return BigInt
  elseif x isa Int64
    return Int64
  else
    return Int
  end
end

start_time = time()

for n in 1:100000
  possible_prime = get_possible_prime_from_col(5, BigInt(n)) #TODO se tudo for BIGINT, demora pra krl
  push!(possible_primes, possible_prime)
  check_prime(possible_prime, BigInt(n))
end

end_time = time()

primes_array = collect(setdiff!(possible_primes, confirmed_non_primes))
println(sort!(primes_array))
println("Primes Found: $(length(primes_array))")
println("Estimated Time: $(end_time - start_time) seconds")
