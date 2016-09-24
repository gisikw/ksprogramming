// Slope test
wait until rcs.
rcs off.
lock g to body:mu / ((ship:altitude + body:radius)^2).

function slope {
  local east is vcrs(north:vector, up:vector).
  local a is body:geopositionof(ship:position + 5 * north:vector).
  local b is body:geopositionof(ship:position - 5 * north:vector + 5 * east).
  local c is body:geopositionof(ship:position - 5 * north:vector - 5 * east).

  local a_vec is a:altitudeposition(a:terrainheight).
  local b_vec is b:altitudeposition(b:terrainheight).
  local c_vec is c:altitudeposition(c:terrainheight).

  return vcrs(c_vec - a_vec, b_vec - a_vec).
}

local target_twr is 0.
local east is heading(90, 0):vector.

local desired_velocity is v(0, 0, 0).
lock delta_velocity to desired_velocity - velocity:surface.
lock steering to lookdirup(up:vector * g + delta_velocity, ship:facing:topvector).

lock maxtwr to ship:maxthrust / (g * ship:mass).
lock throttle to min(target_twr / maxtwr, 1).

set ship:control:pilotmainthrottle to 0.
stage.

local current_vec is vecdraw(v(0,0,0), slope(), rgb(1,0,0), ""+vang(slope(), up:vector), 1, true).
local x_vec is vecdraw(v(0,0,0), vxcl(up:vector, slope()), rgb(0,0,1), "", 1, true).

local pid is pidloop(2.7, 4.4, 0.12, 0, maxtwr).
set pid:setpoint to 1.
until 0 {
  set current_vec to vecdraw(v(0,0,0), slope(), rgb(1,0,0), ""+vang(slope(), up:vector), 1, true).
  set x_vec to vecdraw(v(0,0,0), vxcl(up:vector, slope()), rgb(0,0,1), "", 1, true).
  if alt:radar > 15 and pid:setpoint <> 0 set pid:setpoint to 0.
  if rcs { rcs off. set desired_velocity to desired_velocity + east. }
  if sas { sas off. set desired_velocity to desired_velocity - east. }
  set target_twr to pid:update(time:seconds, ship:verticalspeed) / cos(vang(up:vector, ship:facing:forevector)).
  wait 0.01.
}
