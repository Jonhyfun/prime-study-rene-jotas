find_col_by_five_col = Dict(1 => 5, 6 => 7, 2 => 11, 3 => 13)

function getPositionFactorInCol(number::BigInt, col::Int)
  return Rational(number - col, 12) + 1
end

function isMersenneP(p::BigInt)
  # Check for form p = 2^k ± 1
  for k in 1:floor(Int, log2(p + 1))
    if p == 2^k + 1
      return "p = $p satisfies the form 2^$k + 1"
    elseif p == 2^k - 1
      return "p = $p satisfies the form 2^$k - 1"
    end
  end

  # Check for form p = 4k ± 3
  for k in 1:div(p + 3, 4)
    if p == 4 * k + 3
      return "p = $p satisfies the form 4 * $k + 3"
    elseif p == 4 * k - 3
      return "p = $p satisfies the form 4 * $k - 3"
    end
  end

  return "p = $p does not satisfy any special form."
end

function getPrimePosition(number::BigInt)
  possiblePositionDenomminator = denominator(getPositionFactorInCol(number, 5))

  if possiblePositionDenomminator in keys(find_col_by_five_col)
    col = find_col_by_five_col[possiblePositionDenomminator]
    position = getPositionFactorInCol(number, col)
    finalDenominator = denominator(position)

    if finalDenominator != 1
      println("$(number) is not prime")
    else
      return col, position
    end

  else
    return -1
  end
end


function calculate_result(N::BigInt)
  # Calculate the left side
  possible_prime_col_5 = (5 + 12 * (N - 1))

  #left_side = 2^possible_prime_col_5 - 1

  # Calculate the right side
  if N == 1
    line = 3
    result = 7 + 12 * (line - 1)  # Simplified for N = 1
  else
    line = (3 + sum(2^(3 + 2 * (k - 1)) for k in 1:(6*(N-1))))
    result = 7 + 12 * (line - 1)
  end

  #result = "not calculated"

  return possible_prime_col_5, line, result
end

# Example usage:
N = parse(BigInt, ARGS[1])

possible_prime_col_5, line, result = calculate_result(N)
println("For n = $N:")
println("")
println("p: $(possible_prime_col_5)")
#println(isMersenneP(possible_prime_col_5))
println("Prime: $result")
println("Perfect Number: $(2^(possible_prime_col_5-1)*(2^possible_prime_col_5 - 1))")

#col, line = getPrimePosition(BigInt(result))
col = 7 # our sigma to get the binary shift travels through col 7.
if denominator(line) == 1
  println("Col: $(col)")
  println("Line: $(numerator(line))")
else
  println("Not prime") #This never runs, as our sigma to get the binary shift travels through col 7.
end