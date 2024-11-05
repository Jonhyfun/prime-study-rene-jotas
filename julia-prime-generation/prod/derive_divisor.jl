function find_n_formula(divisor::BigInt)
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
  n_formula = "n = $(n_minus_1 + 1) + $divisor * k"

  return n_formula
end

# Example usage for divisor 5:
divisor = parse(BigInt, ARGS[1])
n_formula = find_n_formula(divisor)

println("The formula for n is: ", n_formula)
