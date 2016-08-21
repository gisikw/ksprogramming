// Maneuver Library v0.1.0
// Kevin Gisi
// http://youtube.com/gisikw

{
  global maneuver is lex(
    "exec", mnv_exec@
  ).

  function mnv_exec {
    parameter autowarp is false.

    if not hasnode return.

    local n is nextnode.
    local v is n:burnvector.

    local starttime is time:seconds + n:eta - mnv_time(v:mag)/2.
    lock steering to n:burnvector.

    if autowarp { warpto(starttime - 30). }

    wait until time:seconds >= starttime.
    lock throttle to min(mnv_time(n:burnvector:mag), 1).

    until vdot(n:burnvector, v) < 0 {
      if ship:maxthrust < 0.1 stage.
      wait 0.1.
      if ship:maxthrust < 0.1 { break. }
    }
    lock throttle to 0.
    unlock steering.
    remove nextnode.
    wait 0.01.
  }

  function mnv_time {
    parameter dV.

    local g is ship:orbit:body:mu/ship:obt:body:radius^2.
    local m is ship:mass * 1000.
    local e is constant():e.

    local engine_count is 0.
    local thrust is 0.
    local isp is 0.

    list engines in all_engines.
    for en in all_engines if en:ignition and not en:flameout {
      set thrust to thrust + en:availablethrust.
      set isp to isp + en:isp.
      set engine_count to engine_count + 1.
    }

    set isp to isp / engine_count.
    set thrust to thrust * 1000.

    return g * m * isp * (1 - e^(-dV/(g*isp))) / thrust.
  }
}
