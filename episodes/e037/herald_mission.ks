// Herald Mission Script
// Kevin Gisi
// http://youtube.com/gisikw

{
  local TARGET_ALTITUDE is 100000.

  global herald_mission is lex(
    "sequence", list(
      "preflight", preflight@,
      "launch", launch@,
      "ascent", ascent@,
      "circularize", circularize@,
      "perform_transfer", perform_transfer@,
      "perform_capture", perform_capture@,
      "enable_antennae", enable_antennae@,
      "idle", idle@
    ),
    "events", lex()
  ).

  function preflight {
    parameter mission.
    set ship:control:pilotmainthrottle to 0.
    lock throttle to 1.
    lock steering to heading(90, 90).
    wait 5.
    mission["next"]().
  }

  function launch {
    parameter mission.
    stage. wait 5.
    lock pct_alt to alt:radar / TARGET_ALTITUDE.
    set target_twr to 8.26.
    lock target_pitch to -115.23935 * pct_alt^0.4095114 + 88.963.
    lock throttle to max(min(target_twr / available_twr(), 1), 0). // Honestly, just lock throttle to 1
    lock steering to heading(90, target_pitch).
    mission["next"]().
  }

  function ascent {
    parameter mission.
    if apoapsis > TARGET_ALTITUDE {
      lock throttle to 0.
      lock steering to prograde.
      wait until alt:radar > body:atm:height.
      mission["next"]().
    }
  }

  function circularize {
    parameter mission.

    // Find good circularization dV
    local dV is list(0).
    set dV to hillclimb["seek"](dV, circular_fitness@, 100).
    set dV to hillclimb["seek"](dV, circular_fitness@, 10).
    set dV to hillclimb["seek"](dV, circular_fitness@, 1).

    // Execute maneuver
    add node(time:seconds + eta:apoapsis, 0, 0, dV[0]). wait 0.1.
    maneuver["exec"]().
    panels on. lock throttle to 0.
    wait 1. stage. wait 1.
    mission["next"]().
  }

  function perform_transfer {
    parameter mission.
    local mnv is transfer["seek"](Mun, 40000).
    add mnv. wait 0.01.
    maneuver["exec"](true).
    mission["next"]().
  }

  function perform_capture {
    parameter mission.
    if body = Mun {
      wait 30. // Sometimes SOI can change back-and-forth
      local dV is list(0).
      set dV to hillclimb["seek"](dV, capture_fitness@, 100).
      set dV to hillclimb["seek"](dV, capture_fitness@, 10).
      set dV to hillclimb["seek"](dV, capture_fitness@, 1).

      add node(time:seconds + eta:periapsis, 0, 0, dV[0]). wait 0.1.
      maneuver["exec"](true).
      mission["next"]().
    }
  }

  function enable_antennae {
    parameter mission.
    local p is ship:partstitled("Comms DTS-M1")[0].
    local m is p:getmodule("ModuleRTAntenna").
    m:doevent("Activate").
    m:setfield("target", "Kerbin").

    set p to ship:partstitled("Communotron 16")[0].
    set m to p:getmodule("ModuleRTAntenna").
    m:doevent("Activate").
    mission["next"]().
  }

  function idle {
    parameter mission.
    // Do nothing
  }

  function available_twr {
    local g is body:mu / (ship:altitude + body:radius)^2.
    return ship:maxthrust / g / ship:mass.
  }

  function circular_fitness {
    parameter data.
    local maneuver is node(time:seconds + eta:apoapsis, 0, 0, data[0]).
    local fitness is 0.
    add maneuver. wait 0.01.
    set fitness to -maneuver:orbit:eccentricity.
    remove_any_nodes().
    return fitness.
  }

  // TODO: circular_fitness and capture_fitness should be merged. They only
  // differ in start time.
  function capture_fitness {
    parameter data.
    local maneuver is node(time:seconds + eta:periapsis, 0, 0, data[0]).
    local fitness is 0.
    add maneuver. wait 0.01.
    set fitness to -maneuver:orbit:eccentricity.
    remove_any_nodes().
    return fitness.
  }

  function remove_any_nodes {
    until not hasnode {
      remove nextnode. wait 0.01.
    }
  }
}
