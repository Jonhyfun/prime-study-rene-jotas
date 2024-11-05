include("prime_check.jl")

currentLine = parse(BigInt, ARGS[1])
found = false

function checkMersennePrimalityByLine(line::BigInt)
  prime_in_7th_col = 7 + 12 * (line - 1) + 1

  # Solve for p using log base 2
  p = log2(prime_in_7th_col)

  # println("The value of p is: ", p)

  if isinteger(p)
    println("2^$(BigInt(p)) - 1 IS A MERSENNE PRIME! (highly likely)")
    global found = true
  end
end


num = currentLine
while found == false
  possible_prime = 7 + 12 * (num - 1) 
  
  if is_prime(possible_prime) 
    checkMersennePrimalityByLine(num)
    println("currently at line $(num)")
  else
    # println("$(possible_prime) is not prime.")
  end
  global num += 1
end
