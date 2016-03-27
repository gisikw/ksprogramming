// Maneuver Node Transfer Library
// Kevin Gisi
// http://youtube.com/gisikw

{global transfer is lex(
  "version", "0.1.0",
  "seek", seek@
).

local MAX_AXIS_DELTA_V is 5000.
local MANEUVER_LEAD_TIME is 600.
local seek_time is 0.

function seek {
  parameter target_body, target_periapsis.
  set seek_time to time:seconds + MANEUVER_LEAD_TIME.
  local ga is lex(
    "population", starting_population(),
    "fitness_fn", maneuver_fitness_fn@,
    "terminate_fn", maneuver_terminate_fn@
  ).
  return decode(genetics["seek"](ga)["best"]).

  function starting_population {
    local population is list().
    for i in range(0,50) {
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
    local candidate is decode(chromosome).

    local TRANSFER_PENALTY_WEIGHT is 10000.
    local PERIAPSIS_PENALTY_WEIGHT is 1000.
    local DELTA_V_PENALTY_WEIGHT is 1000.

    add candidate.

    // Start off assuming failure
    local transfer_penalty is 1.
    local periapsis_penalty is 1.

    local delta_v_penalty is 1 - gaussian(candidate:deltav:mag, 0, 5000).

    // If we had a correct SOI change, remove transfer penalty
    if candidate:orbit:hasnextpatch and candidate:orbit:nextpatch:body = target_body {
      set transfer_penalty to 0.
      set periapsis_penalty to 1 - gaussian(candidate:orbit:nextpatch:periapsis, target_periapsis, 50000).
    } else {

      // Determine distance at apoapsis
      local maneuver_apoapsis_time is
        time:seconds + nextnode:eta + nextnode:orbit:period / 2.

      // If we're leaving the SOI for another target, use THAT apoapsis
      if candidate:orbit:hasnextpatch {
        set maneuver_apoapsis_time to
          time:seconds + nextnode:eta + nextnode:orbit:period / 2 + nextnode:orbit:nextpatch:period / 2.
      }

      local target_position is positionat(target_body, maneuver_apoapsis_time).
      local ship_position is positionat(ship, maneuver_apoapsis_time).

      set transfer_penalty to 1 - gaussian((target_position - ship_position):mag, 0, abs(target_body:orbit:semimajoraxis - ship:orbit:semimajoraxis) / 2).
    }

    local score is 1 / (
      1 +
      transfer_penalty * TRANSFER_PENALTY_WEIGHT +
      periapsis_penalty * PERIAPSIS_PENALTY_WEIGHT +
      delta_v_penalty * DELTA_V_PENALTY_WEIGHT
    ).
    wait 0.25.
    remove candidate.

    return score.
  }

  function decode {
    parameter bitstring.

    local utime is float["to_float"](bitstring:substring(0,32)).
    local radial is float["to_float"](bitstring:substring(32,32)).
    local normal is float["to_float"](bitstring:substring(64,32)).
    local prograde is float["to_float"](bitstring:substring(96,32)).

    if utime <> 0 set utime to max(min(1 / utime, 1), -1).
    if radial <> 0 set radial to max(min(1 / radial, 1), -1).
    if normal <> 0 set normal to max(min(1 / normal, 1), -1).
    if prograde <> 0 set prograde to max(min(1 / prograde, 1), -1).

    return node(
      floor(utime * max(target_body:orbit:period, ship:obt:period) + seek_time),
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
    if hasnode remove nextnode.
    add decode(state["best"]).
    hudtext(
      "Generation " + state["generation"] +
      " - Score: " + state["best_fitness"] +
      " DeltaV: " + nextnode:deltav:mag,
      5, 2, 50, yellow, false).
    wait 2.
    remove nextnode.
    //if state["generation"] = 100 return true.
  }}
}
