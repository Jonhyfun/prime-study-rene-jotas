include("prime_check.jl")

open("possible_mersenne_p.txt", "r") do file
  for line in eachline(file)
    num = parse(BigInt,line)
    println("$(num) is prime? $(is_prime(num))")
  end
end