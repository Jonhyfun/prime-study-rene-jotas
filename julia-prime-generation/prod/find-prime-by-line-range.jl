include("prime_check.jl")

col = parse(Int, ARGS[1])
lineA = parse(BigInt, ARGS[2])
lineB = parse(BigInt, ARGS[3])

for num in lineA:lineB
  possible_prime = col + 12 * (num - 1) 

  # Specify the file name
  file_name = "$(col)_possible_prime_$(num).txt"
  
  # Open the file and write the value of n
  
  if is_prime(possible_prime) 
    open(file_name, "w") do file
        write(file, string(possible_prime))
    end
    println("$(possible_prime) is prime!")
    println("The value of a possible prime from the $(num)th collumn in the selected index has been saved to ", file_name)
  else
    println("$(possible_prime) is not prime.")
  end
end
