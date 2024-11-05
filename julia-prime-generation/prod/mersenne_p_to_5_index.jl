  # Script Julia para calcular Y baseado em um valor fornecido de X
# Equação: Y = (log2(3X - 1) + 9) / 12

# Função para calcular Y
function calcular_y(x::BigInt)
  # Verifica se 3X - 1 é positivo
  if 3x - 1 <= 0
      error("O valor de X deve ser maior que 1/3 para que 3X - 1 seja positivo.")
  end

  # Calcula o logaritmo de base 2
  L = log2(3x - 1)

  # Calcula Y
  y = (L + 9) / 12

  return y
end

# Exemplo de uso
# Solicita ao usuário que insira o valor de X
x = parse(BigInt, ARGS[1])

# Verifica se X é válido
if x > 1/3
  y = calcular_y(x)
  println("O valor de Y para X = $x é:")
  println("Y = $y")
else
  println("Por favor, insira um número real positivo maior que 1/3 para X.")
end
