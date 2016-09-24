// Tuned Hover Awesome Steering Test
wait until rcs.
rcs off.

lock g to body:mu / ((ship:altitude + body:radius)^2).

local target_twr is 0.
local east is heading(90, 0):vector.

local desired_velocity is v(0, 0, 0).
lock delta_velocity to desired_velocity - velocity:surface.
lock steering to lookdirup(up:vector * g + delta_velocity, ship:facing:topvector).

lock maxtwr to ship:availablethrust / (g * ship:mass).
lock throttle to min(target_twr / maxtwr, 1).

set ship:control:pilotmainthrottle to 0.
stage.

local pid is pidloop(2.7, 4.4, 0.12, 0, maxtwr).
set pid:setpoint to 1.
until 0 {
  if alt:radar > 15 and pid:setpoint <> 0 set pid:setpoint to 0.
  if rcs { rcs off. set desired_velocity to desired_velocity + east. }
  if sas { sas off. set desired_velocity to desired_velocity - east. }
  set target_twr to pid:update(time:seconds, ship:verticalspeed) / cos(vang(up:vector, ship:facing:forevector)).
  wait 0.01.
}
