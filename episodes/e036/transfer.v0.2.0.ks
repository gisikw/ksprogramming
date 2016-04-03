// Maneuver Node Transfer Library v0.2.0
// Kevin Gisi
// http://youtube.com/gisikw

{
  local MANEUVER_LEAD_TIME is 6000.
  local SLOPE_THRESHHOLD is 1.

  global transfer is lex(
    "version", "0.2.0",
    "seek", seek@
  ).

  function seek {
    parameter target_body, target_periapsis.
    remove_any_nodes().
    local data is starting_data().
    set data to hillclimb["seek"](data, transfer_fit(target_body), 10).
    // Eventually:
    // set data to hillclimb["seek"](data, inclination_fit(), 1).
    // set data to hillclimb["seek"](data, periapsis_fit(target_periapsis), 1).
    // set data to hillclimb["seek"](data, deltav_fit(), 1).
    remove_any_nodes().
    return make_node(data).
  }

  function transfer_fit {
    parameter target_body.
    function fitness_fn {
      parameter data.
      local maneuver is make_node(data).
      remove_any_nodes().
      add maneuver.
      if transfers_to(maneuver, target_body) return 1.
      local fitness is -closest_approach(
        target_body,
        time:seconds + maneuver:eta,
        time:seconds + maneuver:eta + maneuver:orbit:period
      ).
      print "Fitness: " + fitness.
      return fitness.
    }
    return fitness_fn@.
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
    parameter maneuver, target_body.
    return (
      maneuver:orbit:hasnextpatch and
      maneuver:orbit:nextpatch:body = target_body
    ).
  }

  function starting_data {
    return list(time:seconds + MANEUVER_LEAD_TIME, 0, 0, 0).
  }

  function make_node {
    parameter maneuver.
    return node(maneuver[0], maneuver[1], maneuver[2], maneuver[3]).
  }

  function remove_any_nodes {
    until not hasnode {
      remove nextnode. wait 0.01.
    }
  }
}
