n = parse(BigInt, read("$(ARGS[1])", String))

open("mersenne_number.txt", "w") do file
  mersenne = 7 + 12 * (n - 1)
  write(file, string(mersenne))
end