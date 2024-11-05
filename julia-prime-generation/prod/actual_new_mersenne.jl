n = parse(BigInt, read("n_M82590077.txt", String))

open("M82590077.txt", "w") do file
  mersenne = 7 + 12 * (n - 1)
  write(file, string(mersenne))
end