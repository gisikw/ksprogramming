// Genetic Algorithm Library
// Kevin Gisi
// http://youtube.com/gisikw

{global genetics is lex(
  "version", "0.1.0",
  "seek", ga_seek@
).

function ga_seek {
  parameter init. local ga.

  prepare().
  evaluate().

  until done() {
    select().
    crossbreed().
    mutate().
    evaluate().
  }

  return ga.

  function prepare {
    set ga to init:copy.
    if not ga:haskey("generation") set ga["generation"] to 0.
    if not ga:haskey("best_fitness") set ga["best_fitness"] to 0.
  }

  function evaluate {
    set ga["fitness_scores"] to list().
    for candidate in ga["population"] {
      local fitness is ga["fitness_fn"](candidate).
      if fitness > ga["best_fitness"] {
        set ga["best_fitness"] to fitness.
        set ga["best"] to candidate.
      }
      ga["fitness_scores"]:add(fitness).
    }
    set ga["generation"] to ga["generation"] + 1.
  }

  function done {
    return ga:haskey("terminate_fn") and ga["terminate_fn"](ga).
  }

  function select {
    local total_score is 0, selected is list(),
          len is ga["population"]:length.

    for score in ga["fitness_scores"] set total_score to total_score + score.

    until selected:length = len {
      local i is floor(random()*len).
      if random() < ga["fitness_scores"][i] / total_score {
        selected:add(ga["population"][i]).
      }
    }

    set ga["population"] to selected.
  }

  function crossbreed {
    local children is list().

    for i in range(0, ga["population"]:length, 2) {
      local a is ga["population"][i], b is ga["population"][i+1],
            len is a:length, split is floor(random() * len).
      set ga["population"][i] to
        a:substring(0, split) + b:substring(split, len-split)).
      set ga["population"][i+1] to
        b:substring(0, split) + a:substring(split, len-split).
    }
  }

  function mutate {
    local len is ga["population"][0]:length.

    for i in range(0, ga["population"]) {
      for j in range(0, len) {
        if random() < 1 / len {
          local bit is ga["population"][i]:substring(j,1).
          if bit = "1" set bit to "0". else set bit to "1".
          set ga["population"][i] to
            ga["population"][i]:insert(j,bit):remove(j+1,1).
        }
      }
    }
  }
}}
