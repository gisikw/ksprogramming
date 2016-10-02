// Vanguard Mission Script
// KSProgramming - Cheers Kevin Games

local transfer is import("transfer").
local mission is import("mission").
local suicide is import("suicide").

local TARGET_ALTITUDE is 100000.
local TARGET_MUNAR_ALTITUDE is 20000.
local TARGET_RETURN_ALTITUDE is 30000.
local REENTRY_BURN_ALTITUDE is 100000.
local freeze is transfer["freeze"].

local vanguard_mission is mission(mission_definition@).
function mission_definition {
  parameter seq, ev, next.

  seq:add(prelaunch@).
  function prelaunch {
    set ship:control:pilotmainthrottle to 0.
    gear off.
    lock throttle to 1.
    lock steering to heading(90, 90).
    wait 10.
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
      lock throttle to 0.
      panels on.
      next().
    }
  }

  seq:add(perform_transfer@).
  function perform_transfer {
    transfer["seek_SOI"](Mun, 0).
    transfer["exec"](true).
    next().
  }

  seq:add(perform_correction@).
  function perform_correction {
    if not ship:obt:hasnextpatch {
      local correction_time is time:seconds + (eta:apoapsis / 4).
      transfer["seek_SOI"](Mun, 0, freeze(correction_time)).
      transfer["exec"](true).
      wait 1.
    }
    next().
  }

  seq:add(warp_to_soi@).
  function warp_to_soi {
    if body <> Mun and eta:transition > 60 {
      warpto(time:seconds + eta:transition).
    }
    if body = Mun next().
  }

  seq:add(adjust_munar_periapsis@).
  function adjust_munar_periapsis {
    if body = Mun {
      wait 30.
      transfer["seek"](
        freeze(time:seconds + 120),
        freeze(0), freeze(0), 0, { parameter mnv. if mnv:orbit:periapsis < -200000 return 0. return -mnv:orbit:periapsis. }).
      transfer["exec"](true).
      next().
    }
  }

  seq:add(await_near_space@).
  function await_near_space {
    if alt:radar < 120000 {
      set warp to 0.
      next().
    } else {
      set warp to 4.
    }
  }

  seq:add(perform_suicide_burn@).
  function perform_suicide_burn {
    gear on.
    suicide["exec"](lex(
      "burn_cutoff", 50,
      "descent_speed", 7,
      "max_slope", 15,
      "contact_speed", 2,
      "stage_action", safe_stage@
    )).
    list engines in all_engines.
    for en in all_engines set en:thrustlimit to 50.
    next().
  }

  function safe_stage {
    stage. wait 0.
    for fuel in ship:partstitled("FL-T100 Fuel Tank")[0]:resources
      set fuel:enabled to true.
    for fuel in ship:partstitled("FL-T400 Fuel Tank")[0]:resources
      set fuel:enabled to true.
    wait 0.
  }

  seq:add(await_egress@).
  function await_egress {
    if ship:crew():length = 0 { next(). }
  }

  seq:add(await_ingress@).
  function await_ingress {
    if ship:crew():length = 1 { next(). }
  }

  seq:add(perform_secondary_launch@).
  function perform_secondary_launch {
    lock steering to heading(90, 90).
    lock throttle to 1.
    wait 2.
    lock steering to heading(90, 45).
    wait until apoapsis > TARGET_MUNAR_ALTITUDE.
    lock throttle to 0.
    next().
  }

  seq:add(recircularize@).
  function recircularize {
    transfer["seek"](
      freeze(time:seconds + eta:apoapsis),
      freeze(0), freeze(0), 0, { parameter mnv. return -mnv:orbit:eccentricity. }).
    transfer["exec"](true).
    next().
  }

  seq:add(find_return@).
  function find_return {
    transfer["seek_SOI"](Kerbin, TARGET_RETURN_ALTITUDE).
    transfer["exec"](true).
    next().
  }

  seq:add(warp_to_return_soi@).
  function warp_to_return_soi {
    local transition_time is time:seconds + eta:transition.
    warpto(transition_time).
    wait until time:seconds >= transition_time.
    next().
  }

  seq:add(correct_return_periapsis@).
  function correct_return_periapsis {
    if body = Kerbin {
      wait 30.
      transfer["seek"](
        freeze(time:seconds + 120), freeze(0), freeze(0), 0,
        { parameter mnv. return -abs(mnv:orbit:periapsis - TARGET_RETURN_ALTITUDE). }).
      transfer["exec"](true).
      next().
    }
  }

  seq:add(perform_reentry_burn@).
  function perform_reentry_burn {
    if ship:altitude < REENTRY_BURN_ALTITUDE {
      lock steering to retrograde.
      lock throttle to 1.
      wait until ship:maxthrust < 1.
      lock throttle to 0.
      stage. wait 0.
      lock steering to srfretrograde.
      next().
    }
  }

  seq:add(await_final_landing@).
  function await_final_landing {
    if ship:status = "Landed" next().
  }
}

export(vanguard_mission).
