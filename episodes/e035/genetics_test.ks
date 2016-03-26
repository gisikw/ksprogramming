// Genetic Algorithm Usage Test

run genetics.ks.
run float.ks.
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
  for c in range(0, chromosome:length) {
    if chromosome:substring(c,1) = "0" set result to result + 1.
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

clearscreen.
print "=== RESULTS OF FIVE GENERATIONS ===".
print "GA['generation']".
print ga["generation"].
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

function terminate_fn {
  parameter state.
  print "Generation " + state["generation"] + ": " + state["best"] + " (" + state["best_fitness"] + ")".
  return state["best_fitness"] = 8.
}

wait 3.
clearscreen.
set ga to genetics["seek"](ga).

print "=== RESULTS OF OPEN-ENDED GENERATIONS ===".
print "GA['generation']".
print ga["generation"].
print "GA['best']".
print ga["best"].
print "GA['best_fitness']".
print ga["best_fitness"].

// Testing More Complex Answer
set ga to lex(
  "population", list(
    float["to_bitstring"](random()),
    float["to_bitstring"](random()),
    float["to_bitstring"](random()),
    float["to_bitstring"](random()),
    float["to_bitstring"](random()),
    float["to_bitstring"](random()),
    float["to_bitstring"](random()),
    float["to_bitstring"](random()),
    float["to_bitstring"](random()),
    float["to_bitstring"](random())
  ),
  "fitness_fn", gauss@,
  "terminate_fn", monit@
).

function gauss {
  parameter chromosome.
  return gaussian(float["to_float"](chromosome), 0.1189998819991197253, 0.01).
}

function gaussian {
  parameter value, target, width.
  return constant:e^(-1 * (value-target)^2 / (2*width^2)).
}

function monit {
  parameter state.
  local best is state["best"].
  if best <> 0 set best to float["to_float"](best).
  print "Generation " + state["generation"] + ": " + best + " (" + state["best_fitness"] + ")".
  return state["generation"] = 50.
}

wait 3.
clearscreen.
set ga to genetics["seek"](ga).
print "=== Results of Gaussian Seek ===".
print "GA['generation']".
print ga["generation"].
print "GA['best']".
print ga["best"].
print "GA['best_fitness']".
print ga["best_fitness"].
