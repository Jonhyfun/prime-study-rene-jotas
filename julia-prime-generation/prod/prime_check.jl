using Random

function is_prime(n::BigInt, k::Int=12) # k is the number of iterations
    if n <= 1
        return false
    elseif n <= 3
        return true
    elseif n % 2 == 0
        return false
    end

    # Write n-1 as d * 2^r
    r, d = 0, n - 1
    while d % 2 == 0
        d >>= 1
        r += 1
    end

    # Witness loop
    for _ in 1:k
        a = rand(2: n - 2) # Random base
        x = powermod(a, d, n)  # Use powermod to prevent overflow
        if x == 1 || x == n - 1
            continue
        end
        for _ in 1:(r - 1)
            x = powermod(x, 2, n)  # Use powermod to prevent overflow
            if x == n - 1
                break
            end
        end
        if x != n - 1
            return false
        end
    end
    return true
end
