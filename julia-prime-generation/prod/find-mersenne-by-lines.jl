function checkMersennePrimalityByLine(line::BigInt)
  prime_in_7th_col = 7 + 12 * (line - 1) + 1

  # Solve for p using log base 2
  p = log2(prime_in_7th_col)

  println("The value of p is: ", p)

  if isinteger(p)
    println("2^$(BigInt(p)) - 1 IS A MERSENNE PRIME! (highly likely)")
  end
end

foreach(line -> checkMersennePrimalityByLine(parse(BigInt, line)), ARGS)
