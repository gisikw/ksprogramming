// Maneuver Node Transfer Library
// Kevin Gisi
// http://youtube.com/gisikw


{global transfer is lex(
  "version", "0.1.0",
  "seek", seek@
).

local MAX_AXIS_DELTA_V is 5000.
local MANEUVER_LEAD_TIME is 300.
local seek_time is 0.

function seek {
  parameter target_body, target_periapsis.
  set seek_time to time:seconds.
  local ga is lex(
    "population", starting_population(),
    "fitness_fn", maneuver_fitness_fn@,
    "terminate_fn", maneuver_terminate_fn@
  ).
  return decode(genetics["seek"](ga)["best"]).
}

function starting_population {
  local population is list().
  for i in range(0,20) {
    population:add(
      float["to_bitstring"](random()) +
      float["to_bitstring"](random() * 2 - 1) +
      float["to_bitstring"](random() * 2 - 1) +
      float["to_bitstring"](random() * 2 - 1)
    ).
  }
  return population.
}

function maneuver_fitness_fn {
  parameter chromosome.
  local candidate is decode(chromosome)

  local transfer_score.
  local flyby_score.
  local delta_v_score.

  if candidate:orbit:hasnextpatch and
     candidate:orbit:nextpatch:body = target_body {
    set transfer_score to 1.
    set flyby_score to
      gaussian(candidate:orbit:nextpatch:periapsis, target_periapsis, 50000).
    set delta_v_score to
      gaussian(candidate:deltav:mag, 0, 5000).
  } else {
    set transfer_score to
      gaussian(candidate:orbit:apoapsis, target_body:apoapsis, 10000000).
    set flyby_score to 0.
    set delta_v_score to 0.
  }

  return (
    transfer_score * 1000 +
    + flyby_score * 10000
    + delta_v_score * 1000
  ).
}

function decode {
  parameter bitstring.

  local utime is max(mod(float["to_float"](bitstring:substring(0,32)),1),0).
  local radial is mod(float["to_float"](bitstring:substring(32,32)),1).
  local normal is mod(float["to_float"](bitstring:substring(64,32)),1).
  local prograde is mod(float["to_float"](bitstring:substring(96,32)),1).

  return node(
    utime * max(target_body:orbit:period, ship:obt:period) + seek_time,
    radial * MAX_AXIS_DELTA_V,
    normal * MAX_AXIS_DELTA_V,
    prograde * MAX_AXIS_DELTA_V
  ).
}

function gaussian {
  parameter value, target, width.
  return constant:e^(-1 * (value-target)^2 / (2*width^2)).
}

function maneuver_terminate_fn {
  parameter state.
  if hasnextnode nextnode:remove().
  add decode(state["best"]).
  hudtext(
    "Generation " + state["generation"] +
    " - Score: " + state["best_fitness"],
    5, 2, 50, yellow, false).
  wait 1.
  if state["generation"] = 20 return true.
}}
