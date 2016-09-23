// Tuned Hover Test
wait until rcs.
rcs off.

local target_twr is 0.
lock g to body:mu / ((ship:altitude + body:radius)^2).
lock maxtwr to ship:maxthrust / (g * ship:mass).
lock throttle to min(target_twr / maxtwr, 1).

lock steering to heading(90, 90).
set ship:control:pilotmainthrottle to 0.
stage.

local pid is pidloop(2.7, 4.4, 0.12, 0, maxtwr).
set pid:setpoint to 0.
until 0 {
  if rcs { rcs off. set pid:setpoint to pid:setpoint - 1. }
  if sas { sas off. set pid:setpoint to pid:setpoint + 1. }
  set pid:maxoutput to maxtwr.
  set target_twr to pid:update(time:seconds, ship:verticalspeed).
  wait 0.01.
}
