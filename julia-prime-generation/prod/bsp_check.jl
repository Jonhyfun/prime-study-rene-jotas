result = 3

for i in 3:2:parse(BigInt, ARGS[1])
  global result += 2^(i)
  #print("+ 2^$(i)")
end

println(result)