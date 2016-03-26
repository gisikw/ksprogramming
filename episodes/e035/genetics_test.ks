// Genetic Algorithm Usage Test

run genetics.ks.
set SECRET_WORD to "00000000".

set population to list(
  "10110011",
  "11111111",
  "10101100",
  "00101100"
).

function fitness_fn {
  parameter chromosome.
  local result is 0.
  for c in chromosome {
    if c = "0" set result to result + 1.
  }
  return result.
}

// Testing Genetics Seek
set ga to lex(
  "population", population,
  "fitness_fn", fitness_fn@
).

for i in range(0,5) {
  set ga to genetics["seek"](ga).
}

print "GA['generation']".
print ga["generation"].
print "GA['best']".
print ga["best"].
print "GA['fitness_fn']".
print ga["fitness_fn"].
print "GA['best']".
print ga["best"].
print "GA['best_fitness']".
print ga["best_fitness"].

// Testing Genetics Seek Based on Conditions
set ga to lex(
  "population", population,
  "fitness_fn", fitness_fn@,
  "terminate_fn", terminate_fn@
).

set ga to genetics["seek"](ga).
print "GA['generation']".
print ga["generation"].
print "GA['best']".
print ga["best"].
print "GA['fitness_fn']".
print ga["fitness_fn"].
print "GA['best']".
print ga["best"].
print "GA['best_fitness']".
print ga["best_fitness"].
