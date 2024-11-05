# Definir X
X = parse(BigInt, ARGS[1])

# Calcular o valor de Y
log_val = log2(BigInt(3) * X - BigInt(1)) # log base 2
Y = (log_val + 9) / 12

println("$(BigInt(Y))")