 # Código em Julia para calcular X e salvar em um arquivo

# Definir Y
Y = parse(BigInt, ARGS[1])

# Calcular o expoente k = 12Y - 9
k = 12 * Y - 9

# Calcular 2^k usando BigInt
pow = BigInt(2)^k

# Calcular X = (1 + 2^k) / 3
X = (BigInt(1) + pow) ÷ 3

# Escrever X em um arquivo
open("teste.txt", "w") do arquivo
    write(arquivo, string(X))
end

println("O valor de X foi salvo no arquivo 'M82590077.txt'.")