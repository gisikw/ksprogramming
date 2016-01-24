// Genetic Algorithm
// Guess The Number
// Kevin Gisi
// http://youtube.com/gisikw

set TARGET_NUMBER to 42.

function genetic_algorithm {
  local population is starting_population().
  local generation is 1.

  until ending_conditions_met(population, generation) {
    for candidate in population {
      set_fitness_score(candidate).
    }

    clearscreen.
    print "=== Generation " + generation + " ===".
    print population:dump.
    wait 0.1.

    local parents is selection(population).
    local children is crossover(parents).
    mutate(children).

    set generation to generation + 1.
    set population to children.
  }

  clearscreen.
  print "=== Final Generation ===".
  print "(it took " + generation + " generations)".
  print population:dump.
}

function starting_population {
  local population is list().
  from{local i is 0.} until i=6 step{set i to i+1.} do {
    local candidate is lexicon().
    set candidate["fitness"] to -1.
    set candidate["chromosome"] to round(random() * 100).
    population:add(candidate).
  }
  return population.
}

function ending_conditions_met {
  parameter population, generation.
  for candidate in population {
    if candidate["chromosome"] = 42 return true.
  }
  return false.
}

function set_fitness_score {
  parameter candidate.
  local diff is abs(TARGET_NUMBER - candidate["chromosome"]).
  set candidate["fitness"] to 1 / max(diff, 0.01).
}

function selection {
  parameter population.
  local parents is list().

  set total_fitness to 0.
  for candidate in population {
    set total_fitness to total_fitness + candidate["fitness"].
  }

  until parents:length = population:length {
    local candidate is population[floor(population:length * random())].
    if random() < candidate["fitness"] / total_fitness {
      parents:add(candidate).
    }
  }

  return parents.
}

function crossover {
  parameter parents.
  local children is list().
  from{local i is 0.} until i=parents:length step{set i to i+2.} do {
    local mom is parents[i].
    local dad is parents[i+1].

    from{local j is 0.} until j=2 step{set j to j+1.} do {
      local child is lexicon().
      set child["fitness"] to -1.
      if random() < 0.5 {
        set child["chromosome"] to round((mom["chromosome"] + dad["chromosome"])/2).
      } else {
        if random() < 0.5 {
          set child["chromosome"] to mom["chromosome"].
        } else {
          set child["chromosome"] to dad["chromosome"].
        }
      }
      children:add(child).
    }

  }
  return children.
}

function mutate {
  parameter children.
  for candidate in children {
    if random() < 0.2 {
      if random() < 0.5 {
        set candidate["chromosome"] to candidate["chromosome"] + round(random() * 3).
      } else {
        set candidate["chromosome"] to candidate["chromosome"] - round(random() * 3).
      }
    }
  }
}

clearscreen.
genetic_algorithm().
