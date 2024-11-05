function n_of_possible_prime(col::BigInt, prime::BigInt)
    n = (prime - col) ÷ 12 + 1
    return n
end

function possible_prime_for_col(col::BigInt, n::BigInt)
  return col + 12 * (n - 1)
end

# when p is from col 5
function mersenne_line_from_col_7(n::BigInt) # bitshift 10 to the left that will generate the number always ending in 3, that is a very likely mersenne col 7 n (ie: 10923 is the line of mersenne 2^17-1 where 17 is always from col 5)
  return (1 + 2^(12*n-9))÷3
end

function n_for_mersenne_line_from_m(line::BigInt)
  n = (log2(3 * line - 1) + 9) ÷ 12
  return n
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

function factor_perfect_number(n::BigInt)
  power = 0
  factor = n
  while factor % 2 == 0
    factor = factor ÷ 2
    power += 1 # se printar isso vamos ter 2^factor * n = numero perfeito
  end
  return [factor, power]
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

find_col_by_five_col = Dict(1 => 5, 6 => 7, 2 => 11, 3 => 1)
function is_in_prime_range(possible_prime::BigInt)
  possiblePositionDenominator = denominator(Rational(possible_prime - 5, 12) + 1)
  finalDenominator = 0
  col = 0

  if possiblePositionDenominator in keys(find_col_by_five_col)
    col = find_col_by_five_col[possiblePositionDenominator]
    position = Rational(possible_prime - col, 12) + 1
    finalDenominator = denominator(position)
  end

  return [finalDenominator, col]
end

max_n = parse(BigInt, ARGS[1])

for n in 1:max_n
  if (n-1) % 5 != 0 && n % 7 != 0 && n+1 % 11 != 0
    mersenne_line =  mersenne_line_from_col_7(n)
    possible_prime = possible_prime_for_col(BigInt(7), mersenne_line)
    possible_perfect_number = possible_perfect_number_from_col_5(n)
    mersenne_p_5 = possible_prime_for_col(BigInt(5), n) # a mersenne from col 5 will generate a col 7 mersenne prime that the p always ends with 3 (3 bitshift of 10 to the left)
    println("$(mersenne_p_5) $(n) $(mersenne_line)")
    #if possible_perfect_number == possible_prime * 2^(mersenne_p_5-1) 
    #  factor = factor_perfect_number(possible_perfect_number)
    #  coords = Rational(factor[1] - 7, 12) + 1
    #  if denominator(coords) == 1  # all mersennes are from col 7 and all perfect numbers factor to a mersenne
    #    mersenne_prime = (2^mersenne_p_5) - 1 #TODO entender quando o numero perfeito não é perfeito
    #    if is_in_prime_range(mersenne_prime)[1] == 1 #? acho que isso aqui é inutil? talvez já seja verdade sempre por causa das operações anteriores
    #      if lucas_lehmer(mersenne_p_5)
    #        println("$(n) $(factor[2])")
    #      end
    #    end
    #  end
    #end
  end
end