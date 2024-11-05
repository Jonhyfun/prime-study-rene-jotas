# This file is a modified to convert to julia part of Alpertron Calculators.
# I Jotas, just took the alpertron source code in github and used chatGPT to turn it into a julia script
#
# Copyright 2021 Dario Alejandro Alpern
#
# Alpertron Calculators is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# Alpertron Calculators is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with Alpertron Calculators. If not, see <http://www.gnu.org/licenses/>.

const NBR_LIMBS = 2  # Number of limbs
const LIMB_RANGE = 2^31
const HALF_INT_RANGE = LIMB_RANGE ÷ 2
const MAX_VALUE_LIMB = LIMB_RANGE - 1
const MAX_INT_NBR = LIMB_RANGE - 1
const BITS_PER_GROUP = 31
const FOURTH_INT_RANGE = LIMB_RANGE ÷ 4
const SMALL_NUMBER_BOUND = 32768

# Initialization of necessary variables
TestNbr = zeros(Int64, NBR_LIMBS)
MontgomeryMultN = 0
MontgomeryMultR1 = zeros(Int64, NBR_LIMBS+1)

primes = [2, 3, 5, 7, 11, 13, 17, 19, 23, 29, 31, 37, 41, 43, 47, 53, 59, 61, 67, 71, 73, 79, 83, 89, 97]

# Function to get a prime from the list by index
function getPrime(index::Int)
    return primes[index]
end

# AdjustModN: Adjust the modulus of a number based on the current TestNbr
function AdjustModN(Nbr::Array{Int64,1})
    dVal = 1.0 / LIMB_RANGE
    dSquareLimb = LIMB_RANGE * LIMB_RANGE
    dModulus = TestNbr[2] + TestNbr[1] * dVal
    dNbr = Nbr[3] * LIMB_RANGE + Nbr[2] + Nbr[1] * dVal
    TrialQuotient = floor(Int, dNbr / dModulus + 0.5)

    if TrialQuotient >= LIMB_RANGE
        TrialQuotient = MAX_VALUE_LIMB
    end

    dTrialQuotient = TrialQuotient
    carry = 0
    dDelta = 0.0

    for i in 1:NBR_LIMBS
        low = (Nbr[i] - TestNbr[i] * TrialQuotient + carry) & MAX_INT_NBR
        dAccumulator = Nbr[i] - (TestNbr[i] * dTrialQuotient) + carry + dDelta
        dDelta = 0.0
        if dAccumulator < 0.0
            dAccumulator += dSquareLimb
            dDelta = -LIMB_RANGE
        end
        if low < HALF_INT_RANGE
            carry = floor((dAccumulator + FOURTH_INT_RANGE) * dVal)
        else
            carry = floor((dAccumulator - FOURTH_INT_RANGE) * dVal)
        end
        Nbr[i] = low
    end
    Nbr[NBR_LIMBS+1] = (Nbr[NBR_LIMBS+1] + carry) & MAX_INT_NBR

    if Nbr[NBR_LIMBS+1] & MAX_VALUE_LIMB != 0
        cy = 0
        for i in 1:NBR_LIMBS
            cy += Nbr[i] + TestNbr[i]
            Nbr[i] = cy & MAX_VALUE_LIMB
            cy >>= BITS_PER_GROUP
        end
        Nbr[NBR_LIMBS] = 0
    end
end

# smallmodmult: Modular multiplication for small numbers
function smallmodmult(factor1::Int64, factor2::Int64, mod::Int64)
    if mod < SMALL_NUMBER_BOUND
        return factor1 * factor2 % mod
    else
        quotient = floor((factor1 * factor2) / mod + 0.5)
        remainder = (factor1 * factor2) - quotient * mod
        if remainder < 0
            remainder += mod
        end
        return remainder
    end
end

# Montgomery multiplication
function MontgomeryMult(factor1::Array{Int64,1}, factor2::Array{Int64,1}, Product::Array{Int64,1})
    if TestNbr[2] == 0
        Product[1] = smallmodmult(factor1[1], factor2[1], TestNbr[1])
        Product[2] = 0
        return
    end
    # Initializing required values
    TestNbr0 = TestNbr[1]
    TestNbr1 = TestNbr[2]
    Prod0 = 0
    Prod1 = 0
    factor2_0 = factor2[1]
    factor2_1 = factor2[2]
    
    # Start the Montgomery multiplication steps
    Pr = factor1[1] * factor2_0
    MontDig = (Pr * MontgomeryMultN) & MAX_VALUE_LIMB
    Pr = ((Pr - (MontDig * TestNbr0)) >> BITS_PER_GROUP) - (MontDig * TestNbr1) + factor1[1] * factor2_1
    Prod0 = Pr & MAX_VALUE_LIMB
    Prod1 = Pr >> BITS_PER_GROUP

    Pr = factor1[2] * factor2_0 + Prod0
    MontDig = (Pr * MontgomeryMultN) & MAX_VALUE_LIMB
    Pr = ((Pr - (MontDig * TestNbr0)) >> BITS_PER_GROUP) - (MontDig * TestNbr1) + factor1[2] * factor2_1 + Prod1
    Prod0 = Pr & MAX_VALUE_LIMB
    Prod1 = Pr >> BITS_PER_GROUP

    if Prod1 < 0
        carry = Prod0 + TestNbr0
        Prod0 = carry & MAX_VALUE_LIMB
        Prod1 += TestNbr1 + (carry >> BITS_PER_GROUP)
    end
    Product[1] = Prod0
    Product[2] = Prod1
end

# Addition of two large numbers
function AddBigNbrs(Nbr1::Array{Int64,1}, Nbr2::Array{Int64,1}, Sum::Array{Int64,1})
    carry = Nbr1[1] + Nbr2[1]
    Sum[1] = carry & MAX_VALUE_LIMB
    carry = (carry >> BITS_PER_GROUP) + Nbr1[2] + Nbr2[2]
    Sum[2] = carry & MAX_VALUE_LIMB
end

# Subtraction of two large numbers
function SubtBigNbrs(Nbr1::Array{Int64,1}, Nbr2::Array{Int64,1}, Diff::Array{Int64,1})
    borrow = Nbr1[1] - Nbr2[1]
    Diff[1] = borrow & MAX_VALUE_LIMB
    borrow = Nbr1[2] - Nbr2[2] - (borrow >> BITS_PER_GROUP)
    Diff[2] = borrow & MAX_VALUE_LIMB
end

function GetMontgomeryParms()
  N = TestNbr[1]
  if TestNbr[2] == 0
      MontgomeryMultR1[1] = 1
      return
  end
  
  x = N
  x *= (2 - (N * x)) # 4 least significant bits of inverse correct
  x *= (2 - (N * x)) # 8 least significant bits of inverse correct
  x *= (2 - (N * x)) # 16 least significant bits of inverse correct
  x *= (2 - (N * x)) # 32 least significant bits of inverse correct
  MontgomeryMultN = x & MAX_INT_NBR
  MontgomeryMultR1[2] = 1
  MontgomeryMultR1[1] = 0
  AdjustModN(MontgomeryMultR1)
end

function isPrime(value::Vector{Int32})::Bool
  # Constant values
  bases = [2, 3, 5, 7, 11, 13, 17, 19, 23]
  
  limits = [
      0, 0,
      2047, 0,
      1373653, 0,
      25326001, 0,
      1067548103, 1,
      524283451, 1002,
      121117919, 1618,
      1387448513, 159046,
      1387448513, 159046,
      0, 2000000000
  ]

  # Local variables
  i = 0
  j = 0
  indexLSB = 0
  indexMSB = 0
  idxNbrMSB = 0
  mask = 0
  maskMSB = 0
  prevBase = 1
  base = 0
  tmp = 0
  baseInMontRepres = zeros(Int32, NBR_LIMBS)
  power = zeros(Int32, NBR_LIMBS)
  temp = zeros(Int32, NBR_LIMBS)

  # Convert parameter to big number (2 limbs of 31 bits each)
  TestNbr0 = value[1]
  TestNbr1 = value[2]

  if TestNbr1 >= HALF_INT_RANGE
      # If number is negative, change sign.
      if TestNbr0 == 0
          TestNbr1 = -TestNbr1 & MAX_VALUE_LIMB
      else
          TestNbr0 = -TestNbr0 & MAX_VALUE_LIMB
          TestNbr1 = (-1 - TestNbr1) & MAX_VALUE_LIMB
      end
  end
  TestNbr = [TestNbr0, TestNbr1]

  if TestNbr1 == 0
      if TestNbr0 == 1
          return false  # 1 is not prime
      elseif TestNbr0 == 2
          return true   # 2 is prime
      end
  end

  if (TestNbr0 & 1) == 0
      return false  # Even numbers different from 2 are not prime
  end

  # Check for small primes
  for base in bases
      if TestNbr1 == 0
          if UInt32(TestNbr0) == base
              return true  # Number is prime
          elseif UInt32(TestNbr0) % base == 0
              return false  # Number is composite
          end
      elseif (((UInt32(TestNbr1) % base) * (LIMB_RANGE % base) + UInt32(TestNbr0)) % base) == 0
          return false  # Number is composite
      end
  end

  # Montgomery representation
  GetMontgomeryParms()
  baseInMontRepres[1] = MontgomeryMultR1[1]
  baseInMontRepres[2] = MontgomeryMultR1[2]

  # Find least significant bit (LSB)
  mask = TestNbr0 & (MAX_INT_NBR - 1)
  indexLSB = 0
  if mask == 0
      mask = TestNbr1
      indexLSB = BITS_PER_GROUP
  end
  if (mask & 0xFFFF) == 0
      mask >>= 16
      indexLSB += 16
  end
  if (mask & 0xFF) == 0
      mask >>= 8
      indexLSB += 8
  end
  if (mask & 0x0F) == 0
      mask >>= 4
      indexLSB += 4
  end
  if (mask & 0x03) == 0
      mask >>= 2
      indexLSB += 2
  end
  if (mask & 0x01) == 0
      indexLSB += 1
  end

  # Find most significant bit (MSB)
  mask = TestNbr1
  indexMSB = BITS_PER_GROUP
  idxNbrMSB = 1
  if mask == 0
      mask = TestNbr0
      indexMSB = 0
      idxNbrMSB = 0
  end
  if (mask & 0xFFFF0000) != 0
      mask >>= 16
      indexMSB += 16
  end
  if (mask & 0xFF00) != 0
      mask >>= 8
      indexMSB += 8
  end
  if (mask & 0xF0) != 0
      mask >>= 4
      indexMSB += 4
  end
  if (mask & 0x0C) != 0
      mask >>= 2
      indexMSB += 2
  end
  if (mask & 0x02) != 0
      indexMSB += 1
  end

  tmp = 1
  maskMSB = tmp << (indexMSB % BITS_PER_GROUP)

  # Miller-Rabin test loop
  while limits[j + 1] < TestNbr1 || (limits[j + 1] == TestNbr1 && limits[j] <= TestNbr0)
      base = bases[i]
      # Compute base in Montgomery representation
      while prevBase < base
          AddBigNbrModN(baseInMontRepres, MontgomeryMultR1, baseInMontRepres)
          prevBase += 1
      end
      i += 1
      j += 2

      # Initialize power with base in Montgomery representation
      power[1] = baseInMontRepres[1]
      power[2] = baseInMontRepres[2]

      mask = maskMSB
      idxNbr = idxNbrMSB

      # Main loop
      for index = indexMSB-1:-1:indexLSB
          mask >>= 1
          if mask == 0
              mask = HALF_INT_RANGE
              idxNbr -= 1
          end

          MontgomeryMult(power, power, power)

          if (TestNbr[idxNbr] & mask) != 0
              MontgomeryMult(power, baseInMontRepres, power)
          end
      end

      # Check results
      if power[1] == MontgomeryMultR1[1] && power[2] == MontgomeryMultR1[2]
          continue  # Another base must be tried
      end
      AddBigNbrModN(power, MontgomeryMultR1, temp)
      if temp[1] == 0 && temp[2] == 0
          continue  # Another base must be tried
      end

      for index = indexMSB:-1:0
          mask >>= 1
          if mask == 0
              mask = HALF_INT_RANGE
              idxNbr -= 1
          end
          MontgomeryMult(power, power, power)
          if power[1] == MontgomeryMultR1[1] && power[2] == MontgomeryMultR1[2]
              return false  # Composite number found
          end
          AddBigNbrModN(power, MontgomeryMultR1, temp)
          if temp[1] == 0 && temp[2] == 0
              break  # power equals -1
          end
      end

      if index >= 0
          continue  # Another base must be tried
      end
      return false  # Composite number found
  end

  return true  # Prime number
end

function bigint_to_vector_int32(n::BigInt)
  result = Int32[]
  base = BigInt(2)^32
  while n > 0
      push!(result, Int32(n % base))  # Get the remainder and cast it to Int32
      n = n ÷ base                     # Divide by 2^32 to get the next word
  end
  return result
end

println(isPrime(bigint_to_vector_int32(parse(BigInt, ARGS[1]))))