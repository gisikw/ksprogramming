// IEEE 754 Single-precision floating point conversion library
// Kevin Gisi
// http://youtube.com/gisikw
//
// Note: Does not handle NaN, Infinity, -Infinity, or -0 special cases
// Further reading: https://www.wikiwand.com/en/Single-precision_floating-point_format

// Convert an IEEE 754 floating point bitstring to a number.
// Usage: to_float("01000001010001100000000000000000") => 12.375
function to_float {
  parameter s. local exp is 0. local sig is 0.

  // Grab the exponent and significand
  local e_bits is s:substring(1,8).
  local s_bits is s:substring(9,23).

  // Convert the exponent to decimal
  from {local i is 0.} until i=8 step {set i to i+1.} do {
    if e_bits:substring(7-i, 1)="1" set exp to exp+2^i.
  }

  // Use the biased form unsigned-integer
  set exp to exp - 127.

  // Add the implicit leading bit
  if exp=-127 set s_bits to "0"+s_bits.
  else set s_bits to "1"+s_bits.

  // Convert the significand to decimal
  from {local i is 0.} until i=24 step {set i to i+1.} do {
    if s_bits:substring(i,1)="1" set sig to sig+2^(-i).
  }

  // Flip the significand if the leading bit is 1
  if s:substring(0,1)="1" set sig to -sig.

  // Return the significand * 2^(exponent0
  return sig*2^exp.
}

// Convert a number to a IEEE 754 floating point bitstring
// Usage: to_bitstring(12.375) => "01000001010001100000000000000000"
function to_bitstring {
  parameter f.

  // Convert an integer to a bitstring
  function int_to_bits {
    parameter i. local bits is "".
    until i <= 0 { set bits to mod(i,2)+bits. set i to floor(i/2). }
    return bits.
  }

  // Convert a fraction to a bitstring, to a certain precision
  function fraction_to_bits {
    parameter f, p. local bits is "".
    until f=0 or bits:length=p {
      set bits to bits+floor(f*2). set f to mod(f*2,1).
    }
    return bits.
  }

  // Generate the integer and fractional bitstring
  local i_bits is int_to_bits(floor(abs(f))).
  local f_bits is fraction_to_bits(mod(abs(f),1), 23-i_bits:length).

  local exp is 0.
  // If there is an integer component, the exponent is positive
  if i_bits:length>0 set exp to i_bits:length-1.
  else {
    set i to f_bits:indexof("1").
    // If there are no "1"s in the fraction bitstring, the exponent is 0
    if i=-1 set exp to -127.
    // Otherwise, the exponent is negative
    else set exp to i+1.
  }

  // Use the biased form unsigned-integer
  set exp to exp + 127.

  // Generate the exponent bitstring, padding as necessary
  local e_bits is int_to_bits(exp):padleft(8).

  // Generate the sign bit
  local sign_bit is "0".
  if f<0 set sign_bit to "1".

  // Generate the significand with padding, and strip out the implicit bit
  local sig_bits is (i_bits+f_bits):padright(24):substring(1,23).

  // Replace the string padding wiht zeros
  return (sign_bit+e_bits+sig_bits):replace(" ","0").
}
