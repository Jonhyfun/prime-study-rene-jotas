include("prime_check.jl")

reverse_bitshift_power = BigInt(1)
n = BigInt(3)

# Function to find valid (y, p) pairs
function find_valid_pairs(col::BigInt, max_p::BigInt)
  pairs = []
  for p in col:12:max_p
      # Calculate 2^p - 1
      #if is_prime(p) #o verdadeiro problema é o left side ser primo
        right_side = 2^p - 1
        
        found = false
        # Iterate over possible values of y
        while found == false  # Adjust the upper limit as needed
            left_side = 7 + 12 * (n - 1)  # Calculate 7 + 12 * (n - 1)
            
            # Check if the left and right sides match
            if left_side == right_side
              println("n = $n, p = $p, bsp = $reverse_bitshift_power")
              found = true
            end
            
            global reverse_bitshift_power += 2
            global n += 2^reverse_bitshift_power
        end
      #end
  end
end

# Set the maximum value for p
max_p = BigInt(300)

start_time = time()
find_valid_pairs(BigInt(5), max_p)
end_time = time()
elapsed_time = end_time - start_time
println("Elapsed time: $elapsed_time seconds")