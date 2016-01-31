// Genetic Algorithm Initializer
// Kevin Gisi
// http://youtube.com/gisikw

switch to 0.
run float.
run genetics.

local size is 20.
local chromosomes is list().

until chromosomes:length = size {
  local t_mul is 0.75  + (random() * 0.5).
  local t_exp is 0.75  + (random() * 0.5).
  local t_off is 0.75  + (random() * 0.5).
  local p_mul is -100  + (random() * 20).
  local p_exp is 1     + (random() * 2).
  local p_off is 80    + (random() * 20).
  local cut  is  90000 + (random() * 20000).

  local chromosome is "".
  set chromosome to chromosome + to_bitstring(t_mul).
  set chromosome to chromosome + to_bitstring(t_exp).
  set chromosome to chromosome + to_bitstring(t_off).
  set chromosome to chromosome + to_bitstring(p_mul).
  set chromosome to chromosome + to_bitstring(p_exp).
  set chromosome to chromosome + to_bitstring(p_off).
  set chromosome to chromosome + to_bitstring(cut).

  chromosomes:add(chromosome).
}

ga_init(chromosomes).
hudtext("Genetic Algorithm Initialized", 5, 2, 50, yellow, false).
