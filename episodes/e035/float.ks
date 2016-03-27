// IEEE 754 Single-precision floating point conversion library
// Kevin Gisi
// http://youtube.com/gisikw
//
// Note: Does not handle NaN, Infinity, -Infinity, or -0 special cases
// Further reading:
// https://www.wikiwand.com/en/Single-precision_floating-point_format

// Convert an IEEE 754 floating point bitstring to a number and back
// Usage: float["to_float"]("01000001010001100000000000000000") => 12.375
//        float["to_bistring"](12.375) => "01000001010001100000000000000000"

{global float is lex(
  "version", "0.1.0",
  "to_float", to_float@,
  "to_bitstring", to_bitstring@
).

function to_float { parameter s. local exp is 0. local sig is 0.
  local e_bits is s:substring(1,8).
  local s_bits is s:substring(9,23).
  for i in range(0,8) if e_bits:substring(7-i, 1)="1" set exp to exp+2^i.
  set exp to exp - 127.
  if exp=-127 set s_bits to "0"+s_bits.
  else set s_bits to "1"+s_bits.
  for i in range(0,24) if s_bits:substring(i,1)="1" set sig to sig+2^(-i).
  if s:substring(0,1)="1" set sig to -sig.
  return sig*2^exp.
}

function to_bitstring { parameter f.
  function i2b {parameter i. local bits is "".
    until i <= 0 { set bits to mod(i,2)+bits. set i to floor(i/2). }
    return bits.}
  function f2b { parameter f, p. local bits is "".
    until f=0 or bits:length=p
      set bits to bits+floor(f*2). set f to mod(f*2,1).
    return bits.}
  local i_bits is i2b(floor(abs(f))).
  local f_bits is f2b(mod(abs(f),1), 23-i_bits:length).
  local exp is 0.
  if i_bits:length>0 set exp to i_bits:length-1.
  else {set i to f_bits:indexof("1").
        if i=-1 set exp to -127. else set exp to i+1. }
  set exp to exp + 127.
  local e_bits is i2b(exp):padleft(8).
  local sign_bit is "0".
  if f<0 set sign_bit to "1".
  local sig_bits is (i_bits+f_bits):padright(24):substring(1,23).
  return (sign_bit+e_bits+sig_bits):replace(" ","0").
}}
