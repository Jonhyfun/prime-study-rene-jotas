content = read("input_for_n.txt", String)
n = parse(BigInt, strip(content))

# Rearranging the equation to solve for n
possible_prime = 7 + 12 * (n - 1) 

# Specify the file name
file_name = "possible_prime.txt"

# Open the file and write the value of n
open(file_name, "w") do file
    write(file, string(possible_prime))
end

println("The value of a possible prime from the 7th collumn in the selected index has been saved to ", file_name)