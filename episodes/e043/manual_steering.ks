// Tuned Hover Steering Test
wait until rcs.
rcs off.

local target_twr is 0.
lock g to body:mu / ((ship:altitude + body:radius)^2).
lock maxtwr to ship:maxthrust / (g * ship:mass).
lock throttle to min(target_twr / maxtwr, 1).

set ship:control:pilotmainthrottle to 0.
stage.

local pid is pidloop(2.7, 4.4, 0.12, 0, maxtwr).
set pid:setpoint to 1.
until 0 {
  if rcs { rcs off. set pid:setpoint to pid:setpoint - 1. }
  if sas { sas off. set pid:setpoint to pid:setpoint + 1. }
  set target_twr to pid:update(time:seconds, ship:verticalspeed) /
                    cos(vang(up:vector, ship:facing:forevector)).
  wait 0.01.
}
