function gcd(a, b)
  while b != 0
      a, b = b, a % b
  end
  return a
end

function signum(n)
  return n > 0 ? 1 : n < 0 ? -1 : 0
end

function jacobi(a, p)
  a, t = a % p, 1
  while a != 0
      while a % 2 == 0
          a ÷= 2
          if p % 8 in (3, 5)
              t *= -1
          end
      end
      a, p = p, a
      if a % 4 == 3 && p % 4 == 3
          t *= -1
      end
      a %= p
  end
  return p == 1 ? t : 0
end

function u(p, q, m, n)
  # nth element of Lucas U(p, q) sequence mod m
  d, u2, v2, q2 = p * p - 4 * q, 1, p, q
  u, v, q = n % 2 == 1 ? (1, p, q) : (0, 2, 1)
  while n > 1
      u2, v2, q2, n = mod(u2 * v2, m), mod(v2 * v2 - 2 * q2, m), mod(q2 * q2, m), n ÷ 2
      if n % 2 == 1
          u, v = u * v2 + u2 * v, v * v2 + d * u * u2
          u = u % 2 == 0 ? mod(u ÷ 2, m) : mod((u + m) ÷ 2, m)
          v = v % 2 == 0 ? mod(v ÷ 2, m) : mod((v + m) ÷ 2, m)
          q *= q2
      end
  end
  return u
end

function provePrime(n)
  f, fs, fp, r, d = 2, Int[], 1, n + 1, 5
  while fp * fp < n
      if f * f > r
          push!(fs, r)
          break
      end
      while r % f == 0
          r ÷= f
          fp *= f
          if f ∉ fs
              push!(fs, f)
          end
      end
      f += 1
  end
  while jacobi(d, n) != -1
      d = (abs(d) + 2) * signum(d) * -1
  end
  p, q = 1, (1 - d) ÷ 4
  if gcd(d, n) > 1
      return false
  end
  if u(p, q, n, n + 1) != 0
      return false
  end
  for x in fs
      while true
          if gcd(u(p, q, n, (n + 1) ÷ x), n) == 1
              println(d, " ", p, " ", q, " ", x, " ", u(p, q, n, (n + 1) ÷ x))
              break
          end
          p, q = p + 2, p + q + 1
      end
  end
  return true
end

start_time = time()
println(provePrime(parse(BigInt, ARGS[1])))
end_time = time()
println("Execution time: $(end_time - start_time) seconds")
