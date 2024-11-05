
open("M82590077 by factor.txt", "w") do file
  mersenne = 1156261079 * 1429559571440393
  write(file, string(mersenne))
end