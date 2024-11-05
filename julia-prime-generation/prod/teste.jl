# Function to find integer pairs (x, y) that satisfy the equation
function find_solutions(max_x::BigInt, max_y::BigInt)
  solutions = []
  
  for x in 0:max_x
      lhs = 2^x * (2^(x + 1) - 1)
      
      for y in 0:max_y
          rhs = (7 + 12 * (40 * y - 41)) / (2^x)
          
          # Check if LHS is equal to RHS
          if lhs == rhs
              push!(solutions, (x, y))
              println("x: $(x), y: $(y)")
          end
      end
  end
  
  return solutions
end

# Define the maximum values for x and y to check
max_x = BigInt(200)  # You can adjust this range
max_y = BigInt(200)  # You can adjust this range

# Find and print solutions
solutions = find_solutions(max_x, max_y)