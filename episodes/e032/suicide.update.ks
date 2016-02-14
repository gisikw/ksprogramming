// Suicide Burn Test
// Kevin Gisi
// http://youtube.com/gisikw

set MAXIMUM_IMPACT_VELOCITY to 2.

function main {
  initialize_test_conditions().
  local fuel is stage:liquidfuel.
  perform_suicide_burn().
  print "Fuel used: " + (stage:liquidfuel - fuel).
}

function initialize_test_conditions {
  perform_launch().
  wait 10. lock throttle to 0.
  await_test_conditions().
}

function perform_launch {
  lock steering to heading(270,60).
  lock throttle to 1.
  stage.
}

function await_test_conditions {
  wait until ship:verticalspeed < 0.
}

function perform_suicide_burn {
  lock steering to safe_retrograde().
  until ship:status = "Landed" {
    if velocity_at_impact() > MAXIMUM_IMPACT_VELOCITY {
      lock throttle to 1.
    } else lock throttle to 0.
    wait 0.01.
  }
}

function safe_retrograde {
  if ship:verticalspeed < 0 return srfretrograde.
  return heading(90,90).
}

function velocity_at_impact {
  // v = v0 + at
  local v0 is -ship:verticalspeed + abs(ship:groundspeed).
  local a is total_acceleration().
  local t is time_to_impact().

  return v0 + a*t.
}

function total_acceleration {
  local a_grav is body:mu / ((ship:altitude + body:radius)^2).
  local a_thrust is ship:maxthrust / ship:mass.
  return a_grav - a_thrust.
}

function time_to_impact {
  // d = vt + 1/2at^2
  local d is alt:radar.
  local v is -ship:verticalspeed.
  local a is body:mu / ((ship:altitude + body:radius)^2).

  return (sqrt(v^2 + 2 * a * d) - v) / a.
}

main().
