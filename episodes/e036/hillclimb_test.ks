run hillclimbing.v0.1.0.ks.

function my_fitness_fn {
  parameter data.
  return -sqrt((data[0] - 42)^2 + (data[1] - 42)^2).
}

set result to hillclimb["seek"](
  list(0,0),
  my_fitness_fn@
).

print "Should find 42, 42".
print result.
