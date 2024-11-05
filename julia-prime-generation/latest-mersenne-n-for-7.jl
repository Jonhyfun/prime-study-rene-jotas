# Calculate 2^82589933 - 1
power_value = BigInt(2)^82589933 - 1

# Rearranging the equation to solve for n
n = (power_value - 7) ÷ 12 + 1

# Specify the file name
file_name = "output.txt"

# Open the file and write the value of n
open(file_name, "w") do file
    write(file, string(n))
end

println("The value of n has been saved to ", file_name)