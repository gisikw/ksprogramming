local mission is import("mission").
local transfer is import("transfer").
local TARGET_ALTITUDE is 100000.
local TARGET_MUNAR_ALTITUDE is 350000.
local freeze is transfer["freeze"].

local herald_mission is mission(mission_definition@).
function mission_definition {
  parameter seq, ev, next.

  seq:add(prelaunch@).
  function prelaunch {
    set ship:control:pilotmainthrottle to 0.
    lock throttle to 1.
    lock steering to heading(90, 90).
    wait 1.
    next().
  }

  seq:add(launch@).
  function launch {
    stage. wait 5.
    lock pct_alt to alt:radar / TARGET_ALTITUDE.
    lock target_pitch to -115.23935 * pct_alt^0.4095114 + 88.963.
    lock steering to heading(90, target_pitch).
    next().
  }

  seq:add(meco@).
  function meco {
    if apoapsis > TARGET_ALTITUDE {
      lock throttle to 0.
      lock steering to prograde.
      next().
    }
  }

  seq:add(circularize@).
  function circularize {
    if alt:radar > body:atm:height {
      transfer["seek"](
        freeze(time:seconds + eta:apoapsis),
        freeze(0), freeze(0), 0, { parameter mnv. return -mnv:orbit:eccentricity. }).
      transfer["exec"](true).
      wait 0. stage. wait 0.
      panels on.
      next().
    }
  }

  seq:add(perform_transfer@).
  function perform_transfer {
    transfer["seek_SOI"](Mun, TARGET_MUNAR_ALTITUDE).
    transfer["exec"](true).
    next().
  }

  seq:add(perform_correction@).
  function perform_correction {
    transfer["seek_SOI"](Mun, TARGET_MUNAR_ALTITUDE,
                        freeze(time:seconds + (eta:transition / 2))).
    transfer["exec"](true).
    next().
  }

  seq:add(warp_to_soi@).
  function warp_to_soi {
    local transition_time is time:seconds + eta:transition.
    warpto(transition_time).
    wait until time:seconds >= transition_time.
    next().
  }

  seq:add(adjust_munar_periapsis@).
  function adjust_munar_periapsis {
    if body = Mun {
      wait 30.
      transfer["seek"](
        freeze(time:seconds + 120), freeze(0), freeze(0), 0,
        { parameter mnv. return -abs(mnv:orbit:periapsis - TARGET_MUNAR_ALTITUDE). }).
      transfer["exec"](true).
      next().
    }
  }

  seq:add(perform_capture@).
  function perform_capture {
    transfer["seek"](
      freeze(time:seconds + eta:periapsis), freeze(0), freeze(0), 0,
      { parameter mnv. return -mnv:orbit:eccentricity. }).
    transfer["exec"](true).
    next().
  }

  seq:add(enable_antennae@).
  function enable_antennae {
    local p is ship:partstitled("Communotron 16")[0].
    local m is p:getmodule("ModuleRTAntenna").
    m:doevent("Activate").
    set p to ship:partstitled("Communotron DTS-M1")[0].
    set m to p:getmodule("ModuleRTAntenna").
    m:doevent("Activate").
    m:setfield("target", "Kerbin").
    next().
  }
}

export(herald_mission).
