// Vanguard Mission Script
// KSProgramming - Cheers Kevin Games

local transfer is import("transfer").
local mission is import("mission").
local descent is import("descent").

local TARGET_ALTITUDE is 100000.
local TARGET_MUNAR_ALTITUDE is 20000.
local TARGET_RETURN_ALTITUDE is 30000.
local REENTRY_BURN_ALTITUDE is 100000.
local freeze is transfer["freeze"].

local vanguard_mission is mission({ parameter seq, ev, next.
  local avail_thrust is 0.

  seq:add({
    set ship:control:pilotmainthrottle to 0.
    gear off.
    lock throttle to 1.
    lock steering to heading(90, 90).
    wait 10.
    next().
  }).

  seq:add({
    stage. wait 5.
    lock pct_alt to alt:radar / TARGET_ALTITUDE.
    lock target_pitch to -115.23935 * pct_alt^0.4095114 + 88.963.
    lock steering to heading(90, target_pitch).
    set avail_thrust to ship:availablethrust.
    next().
  }).

  seq:add({
    if ship:availablethrust < avail_thrust - 10 {
      stage. wait 1.
      set avail_thrust to ship:availablethrust.
      next().
    }
  }).

  seq:add({
    if ship:availablethrust < avail_thrust - 10 {
      stage. wait 1.
      next().
    }
  }).

  seq:add({
    if apoapsis > TARGET_ALTITUDE {
      lock throttle to 0.
      lock steering to prograde.
      next().
    }
  }).

  seq:add({
    if alt:radar > body:atm:height {
      transfer["seek"](
        freeze(time:seconds + eta:apoapsis),
        freeze(0), freeze(0), 0, { parameter mnv. return -mnv:orbit:eccentricity. }).
      transfer["exec"](true).
      lock throttle to 0.
      panels on.
      next().
    }
  }).

  seq:add({
    transfer["seek_SOI"](Mun, 0).
    transfer["exec"](true).
    next().
  }).

  seq:add({
    if not ship:obt:hasnextpatch {
      local correction_time is time:seconds + (eta:apoapsis / 4).
      transfer["seek_SOI"](Mun, 0, freeze(correction_time)).
      transfer["exec"](true).
      wait 1.
    }
    next().
  }).

  seq:add({
    if body <> Mun and eta:transition > 60 {
      warpto(time:seconds + eta:transition).
    }
    if body = Mun next().
  }).

  seq:add({
    if body = Mun {
      wait 30.
      transfer["seek"](
        freeze(time:seconds + 120),
        freeze(0), freeze(0), 0,
        { parameter mnv.
          if mnv:orbit:periapsis < -100000 return 0.
          return -mnv:orbit:periapsis.
        }
      ).
      transfer["exec"](true).
      next().
    }
  }).

  seq:add({
    if alt:radar < 120000 {
      set warp to 0.
      next().
    } else {
      set warp to 4.
    }
  }).

  seq:add({
    gear on.
    descent["suicide_burn"](3000).
    if stage:number >= 2 {
      lock throttle to 0. wait 0.1. stage. wait 0.1.
    }
    descent["suicide_burn"](50).
    descent["powered_landing"]().
    next().
  }).

  seq:add({ if ship:crew():length = 0 next(). }).
  seq:add({ if ship:crew():length = 1 next(). }).

  seq:add({
    lock steering to heading(90, 90).
    lock throttle to 1.
    wait 2.
    lock steering to heading(90, 45).
    wait until apoapsis > TARGET_MUNAR_ALTITUDE.
    lock throttle to 0.
    next().
  }).

  seq:add({
    transfer["seek"](
      freeze(time:seconds + eta:apoapsis),
      freeze(0), freeze(0), 0,
      { parameter mnv. return -mnv:orbit:eccentricity. }).
    transfer["exec"](true).
    next().
  }).

  seq:add({
    transfer["seek_SOI"](Kerbin, TARGET_RETURN_ALTITUDE).
    transfer["exec"](true).
    next().
  }).

  seq:add({
    local transition_time is time:seconds + eta:transition.
    warpto(transition_time).
    wait until time:seconds >= transition_time.
    next().
  }).

  seq:add({
    if body = Kerbin {
      wait 30.
      transfer["seek"](
        freeze(time:seconds + 120), freeze(0), freeze(0), 0,
        { parameter mnv. return -abs(mnv:orbit:periapsis -
                                     TARGET_RETURN_ALTITUDE). }).
      transfer["exec"](true).
      next().
    }
  }).

  seq:add({
    if alt:radar < REENTRY_BURN_ALTITUDE * 5 {
      set warp to 0.
      next().
    } else {
      set warp to 4.
    }
  }).

  seq:add({
    if ship:altitude < REENTRY_BURN_ALTITUDE {
      lock steering to retrograde.
      lock throttle to 1.
      wait until ship:maxthrust < 1.
      lock throttle to 0.
      stage. wait 0.
      lock steering to srfretrograde.
      next().
    }
  }).

  seq:add({ if ship:status = "Landed" next(). }).
}).

export(vanguard_mission).
