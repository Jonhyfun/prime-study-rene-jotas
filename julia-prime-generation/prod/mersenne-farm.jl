include("prime_check.jl")

content = read("input_current_line.txt", String)
currentLine = parse(BigInt, strip(content))
found = false

function checkMersennePrimalityByLine(line::BigInt)
  prime_in_7th_col = 7 + 12 * (line - 1) + 1 #! essa conta é mto ineficiente (melhor pensar em algo que de pra cortar p ou n direto?) 
  #! (tem algo seriamente errado, se eu somo 1 no N que deveria somar pelo menos 12,
  #TODO  ele dá um falso positivo ou sei lá que retorna o mesmo mersenne que já existe, isso n faz mto sentido)

  # Solve for p using log base 2
  p = log2(prime_in_7th_col)

  # println("The value of p is: ", p)

  if isinteger(p)
    #if BigInt(p) != 82589933
      println("2^$(BigInt(p)) - 1 IS A MERSENNE PRIME! (highly likely)")
      global found = true
    #end
  end
end


num = currentLine
i = 0

while found == false
  global i += 1
  num_digits = floor(BigInt, log10(num) - 12) 
  #TODO  esse - 12 é -12 zeros pra somar, pq somar apenas 1 como dito antes dá um falso positivo,
  #TODO  talvez seja relevante encontrar qual o menor fator que da o falso positivo e rodar ele + 1
  global num += (10)^(num_digits)
  
  possible_prime = 7 + 12 * (num - 1)
  
  #if is_prime(possible_prime) 
    checkMersennePrimalityByLine(num)
    println("currently at iteration $(i) (+ $(i) x 10^$(num/100))")
  #else
    # println("$(possible_prime) is not prime.")
  #end
end
