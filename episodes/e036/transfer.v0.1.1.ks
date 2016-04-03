// Maneuver Node Transfer Library
// Kevin Gisi
// http://youtube.com/gisikw

{
  local MANEUVER_LEAD_TIME is 600.
  local MAX_AXIS_DELTA_V is 5000.
  local MAX_GENERATIONS is 50.
  local MAX_START_TIME is 86400.
  local MIN_APPROACH_TIME is 60.
  local POPULATION_SIZE is 20.

  global transfer is lex(
    "version", "0.1.1",
    "seek", seek@
  ).

  function seek {
    parameter target_body, target_periapsis.
    local reference_time is time:seconds + MANEUVER_LEAD_TIME.
    local ga_problem is
      create_ga_problem(target_body, target_periapsis, reference_time).
    if hasnode remove nextnode.
    local ga_solution is genetics["seek"](ga_problem).
    return create_maneuver_node(ga_solution["best"], reference_time).
  }

  function create_ga_problem {
    parameter target_body, target_periapsis, reference_time.
    return lex(
      "fitness_fn", create_fitness_fn(
        target_body,
        target_periapsis,
        reference_time
      ),
      "population", random_starting_population(),
      "terminate_fn", create_terminate_fn(reference_time)
    ).
  }

  function create_terminate_fn {
    parameter reference_time.
    function terminate_fn {
      parameter ga_solution.
      print "Generation " + ga_solution["generation"] +
        " - Score: " + ga_solution["best_fitness"].
      return false.
      if hasnode remove nextnode.
      add create_maneuver_node(ga_solution["best"], reference_time).
      hudtext(
        "Generation " + ga_solution["generation"] +
        " - Score: " + ga_solution["best_fitness"] +
        " DeltaV: " + nextnode:deltav:mag,
        5, 2, 50, yellow, false).
      print "Generation " + ga_solution["generation"] +
        " - Score: " + ga_solution["best_fitness"] +
        " DeltaV: " + nextnode:deltav:mag.
      wait 5.
      remove nextnode.
      return false.
      //return ga_problem["generation"] >= MAX_GENERATIONS.
    }
    return terminate_fn@.
  }

  function create_fitness_fn {
    parameter target_body, target_periapsis, reference_time.
    function fitness_fn {
      parameter chromosome.
      local maneuver_node is create_maneuver_node(chromosome, reference_time).
      add maneuver_node.
      local fitness_score is
        score(maneuver_node) /
        max(penalties(maneuver_node, target_body, target_periapsis), 0.0001).
      //wait 0.25.
      remove maneuver_node.
      return fitness_score.
    }
    return fitness_fn@.
  }

  function score {
    parameter maneuver_node.
    return gaussian(maneuver_node:deltav:mag, 0, 5000).
  }

  function penalties {
    parameter maneuver_node, target_body, target_periapsis.
    return (
      inclination_penalty(maneuver_node, target_body) +
      periapsis_penalty(maneuver_node, target_body, target_periapsis) +
      soi_transfer_penalty(maneuver_node, target_body)
    ) * 10.
  }

  function inclination_penalty {
    parameter maneuver_node, target_body.
    if not transfers_to(maneuver_node:orbit, target_body) return 1.
    return gaussian(maneuver_node:orbit:nextpatch:inclination, 0, 180).
  }

  function periapsis_penalty {
    parameter maneuver_node, target_body, target_periapsis.
    if not transfers_to(maneuver_node:orbit, target_body) return 1.
    return gaussian(
      maneuver_node:orbit:nextpatch:periapsis,
      target_periapsis,
      target_periapsis / 2
    ).
  }

  function soi_transfer_penalty {
    parameter maneuver_node, target_body.
    if transfers_to(maneuver_node:orbit, target_body) return 0.
    set approach to closest_approach(
      target_body,
      time:seconds + maneuver_node:eta,
      time:seconds + maneuver_node:eta + maneuver_node:orbit:period
    ).
    return 1 - gaussian(approach, 0, target_body:orbit:semimajoraxis / 2).
  }

  function closest_approach {
    parameter target_body, start_time, end_time.
    local start_slope is slope_at(target_body, start_time).
    local end_slope is slope_at(target_body, end_time).
    local middle_time is (start_time + end_time) / 2.
    local middle_slope is slope_at(target_body, middle_time).
    until (end_time - start_time < 0.1) or middle_slope < 0.1 {
      if (middle_slope * start_slope) > 0
        set start_time to middle_time.
      else
        set end_time to middle_time.
      set middle_time to (start_time + end_time) / 2.
      set middle_slope to slope_at(target_body, middle_time).
    }
    return separation_at(target_body, middle_time).
  }

  function slope_at {
    parameter target_body, at_time.
    return (
      separation_at(target_body, at_time + 1) -
      separation_at(target_body, at_time - 1)
    ) / 2.
  }

  function separation_at {
    parameter target_body, at_time.
    return (positionat(ship, at_time) - positionat(target_body, at_time)):mag.
  }

  function transfers_to {
    parameter orbit, target_body.
    return orbit:hasnextpatch and orbit:nextpatch:body = target_body.
  }

  function create_maneuver_node {
    parameter chromosome, reference_time.
    return node(
      maneuver_start_time(chromosome:substring(0, 16), reference_time),
      delta_v(chromosome:substring(16, 16)),
      delta_v(chromosome:substring(32, 16)),
      delta_v(chromosome:substring(48, 16))
    ).
  }

  function maneuver_start_time {
    parameter bits, reference_time.
    return reference_time + MAX_START_TIME * to_fraction(bits).
  }

  function delta_v {
    parameter bits.
    return MAX_AXIS_DELTA_V * to_signed_fraction(bits).
  }

  function random_starting_population {
    local population is list().
    for i in range(0, POPULATION_SIZE)
      population:add(random_chromosome()).
    return population.
  }

  function random_chromosome {
    local chromosome is "".
    for i in range(0, 64)
      set chromosome to chromosome + round(random()).
    return chromosome.
  }

  function to_signed_fraction {
    parameter bits.
    local fraction is to_fraction(bits:substring(1, bits:length - 1)).
    if bits:substring(0, 1) = "1"
      set fraction to -fraction.
    return fraction.
  }

  function to_fraction {
    parameter bits.
    return to_integer(bits) / 2^bits:length.
  }

  function to_integer {
    parameter bits.
    local integer is 0.
    for i in range(0, bits:length)
      if bits:substring(bits:length - i - 1, 1) = "1"
        set integer to integer + 2^i.
    return integer.
  }

  function gaussian {
    parameter value, target, width.
    return constant:e^(-1 * (value-target)^2 / (2*width^2)).
  }
}
