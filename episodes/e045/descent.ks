{
  local NIL is 0.0001.

  local descent is lex(
    "suicide_burn", suicide_burn@,
    "powered_landing", powered_landing@
  ).

  function suicide_burn {
    parameter cutoff.
    local t is 0. lock throttle to t.
    local has_impact_time is {
      local a is (
        g() * (1 - (availtwr() *
                    max(cos(vang(up:vector, ship:facing:vector)), NIL)))).
      local v is -verticalspeed.
      local d is radar() - cutoff.
      return v^2 + 2*a*d > 0.
    }.
    lock steering to descent_vector().
    until radar() < cutoff or ship:availablethrust < 0.1 {
      if has_impact_time() set t to 1.
      else set t to 0.
      wait 0.001.
    }
  }

  function powered_landing {
    local t is 0. lock throttle to t.
    lock steering to descent_vector().
    until alt:radar < 15 { set t to hover(-7). wait 0. }
    until velocity:surface:mag < 0.5 { set t to hover(0). wait 0. }
    until ship:status = "Landed" { set t to hover(-2). wait 0. }
    set t to 0.
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

  function descent_vector {
    if vang(srfretrograde:vector, up:vector) > 90 return unrotate(up).
    return unrotate(up:vector * g() - velocity:surface).
  }

  function unrotate {
    parameter v. if v:typename <> "Vector" set v to v:vector.
    return lookdirup(v, ship:facing:topvector).
  }

  function radar {
    return altitude - body:geopositionof(ship:position):terrainheight.
  }

  function g { return body:mu / ((ship:altitude + body:radius)^2). }
  function availtwr { return ship:availablethrust / (ship:mass * g()). }

  export(descent).
}
