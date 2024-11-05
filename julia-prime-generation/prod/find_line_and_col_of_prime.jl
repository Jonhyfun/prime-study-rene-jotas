filename = "mersenne_p_list.txt"  # Replace with your actual filename

function findPrimeLineCol(number::BigInt) 
  for y in 1:number
    x = number - 12 * (y - 1)
    if x == 5 || x == 7 || x == 11 || x == 13
      if x > 0  # To ensure x remains positive
          println("$(number): (x = $x, y = $y)")
      else
          break  # No need to continue when x becomes negative
      end
      break
    end
  end
end

open(filename, "r") do file
  for line in eachline(file)
    p = parse(BigInt, line)
    findPrimeLineCol(p)
  end
end