local pid_throttle is 0.
lock throttle to pid_throttle.
lock steering to heading(90, 90).
set ship:control:pilotmainthrottle to 0.
stage.

local pid is pidloop(0.05, 0.01, 0.01, 0, 1).
set pid:setpoint to 20.
until ship:liquidfuel < 5 {
  set pid_throttle to pid:update(time:seconds, ship:verticalspeed).
  wait 0.
}
stage.
