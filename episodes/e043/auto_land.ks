// Automatic Lander

local SUICIDE_DISTANCE_MARGIN is 50.
local ACCEPTABLE_LANDING_SLOPE is 5.
local ACCEPTABLE_DRIFT is 0.5.
local CONTACT_SPEED is 2.
local CONTACT_CUTOFF is 15.
local DESCENT_SPEED is 5.

function main {
  set ship:control:pilotmainthrottle to 1.
  sas on.
  wait until abort.
  core:part:getmodule("kOSProcessor"):doevent("Open Terminal").
  clearscreen.
  set terminal:charheight to 14.
  set terminal:charwidth to 14.
  set terminal:brightness to 1.
  set ship:control:pilotmainthrottle to 0.
  sas off.
  display(lex("step", "Suicide burn")).
  perform_suicide_burn().
  display(lex("step", "Slope seek")).
  seek_landing_area().
  display(lex("step", "Landing")).
  land().
}

function perform_suicide_burn {
  local t is 0.
  lock steering to descent_vector().
  lock throttle to t.
  until alt:radar < SUICIDE_DISTANCE_MARGIN {
    if has_impact_time(SUICIDE_DISTANCE_MARGIN) set t to 1.
    else set t to 0.
    wait 0.
  }
}

function has_impact_time {
  parameter margin.
  local a is g() * (1 - availtwr()).
  local v is -verticalspeed.
  local d is alt:radar - margin.
  local tti is v^2 + 2*a*d.
  display(lex("TTI", tti)).
  return tti > 0.
}

function seek_landing_area {
  local target_vector is unrotate(up).
  local t is 1.
  lock throttle to t.
  lock steering to target_vector.
  local slope is vang(ground_slope(), up:vector).
  until slope < ACCEPTABLE_LANDING_SLOPE and
        velocity:surface:mag < ACCEPTABLE_DRIFT {
    set slope to vang(ground_slope(), up:vector).
    local desired_velocity is vxcl(up:vector, ground_slope()).
    set desired_velocity:mag to 2.
    if slope < ACCEPTABLE_LANDING_SLOPE set desired_velocity to v(0, 0, 0).
    local delta_velocity is desired_velocity - velocity:surface.
    set target_vector to unrotate(up:vector * g() + delta_velocity).
    set t to hover(0).
    display(lex("Slope", vang(ground_slope(), up:vector))).
    wait 0.
  }
}

function ground_slope {
  local east is vcrs(north:vector, up:vector).
  local a is body:geopositionof(ship:position + 5 * north:vector).
  local b is body:geopositionof(ship:position - 5 * north:vector + 5 * east).
  local c is body:geopositionof(ship:position - 5 * north:vector - 5 * east).

  local a_vec is a:altitudeposition(a:terrainheight).
  local b_vec is b:altitudeposition(b:terrainheight).
  local c_vec is c:altitudeposition(c:terrainheight).

  return vcrs(c_vec - a_vec, b_vec - a_vec).
}

local hover_pid is pidloop(2.7, 4.4, 0.12, 0, 1).
function hover {
  parameter setpoint.
  set hover_pid:setpoint to setpoint.
  set hover_pid:maxoutput to availtwr().
  return min(
    hover_pid:update(time:seconds, ship:verticalspeed) /
    max(cos(vang(up:vector, ship:facing:vector)), 0.0001) /
    max(availtwr(), 0.0001),
    1
  ).
}

function land {
  local t is 0.
  lock steering to descent_vector().
  lock throttle to t.
  until alt:radar < CONTACT_CUTOFF { set t to hover(-DESCENT_SPEED). wait 0. }
  until velocity:surface:mag < ACCEPTABLE_DRIFT { set t to hover(0). wait 0. }
  until ship:status = "Landed" { set t to hover(-CONTACT_SPEED). wait 0. }
  lock throttle to 0.
}

// Helper functions

function descent_vector {
  if vang(srfretrograde:vector, up:vector) > 90 return unrotate(up).
  return unrotate(up:vector * g() - velocity:surface).
}

local display_data is lex(
  "step", "waiting"
).
function display {
  parameter update is lex().
  for key in update:keys set display_data[key] to update[key].
  local i is 0.
  for key in display_data:keys {
    print (key + ": " +display_data[key]):padright(terminal:width) at (0, i).
    set i to i + 1.
  }
}

function unrotate {
  parameter v. if v:typename <> "Vector" set v to v:vector.
  return lookdirup(v, ship:facing:topvector).
}

function g {
  return body:mu / ((ship:altitude + body:radius)^2).
}

function availtwr {
  return ship:availablethrust / (ship:mass * g()).
}

main().
