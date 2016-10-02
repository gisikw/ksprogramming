{
  local suicide is lex(
    "exec", exec@
  ).

  function exec {
    parameter args.
    local burn_cutoff is args["burn_cutoff"].
    local descent_speed is args["descent_speed"].
    local max_slope is args["max_slope"].
    local contact_speed is args["contact_speed"].
    local stage_action is args["stage_action"].
    local t is 0.
    lock throttle to t.

    perform_burn().
    seek_landing_area().
    land().

    function perform_burn {
      lock steering to descent_vector().
      until alt:radar < burn_cutoff {
        if ship:availablethrust < 1 stage_action().
        if has_impact_time() set t to 1.
        else set t to 0.
        wait 0.001.
      }
    }

    function has_impact_time {
      local a is g() * (1 - (availtwr() * max(cos(vang(up:vector, ship:facing:vector)), 0.0001))).
      local v is -verticalspeed.
      local d is altitude - body:geopositionof(ship:position):terrainheight - burn_cutoff.
      return v^2 + 2*a*d > 0.
    }

    function seek_landing_area {
      local target_vector is unrotate(up).
      lock steering to target_vector.
      set t to 1.
      local slope is vang(ground_slope(), up:vector).
      until slope < max_slope and velocity:surface:mag < 0.5 {
        set slope to vang(ground_slope(), up:vector).
        local desired_velocity is vxcl(up:vector, ground_slope()).
        set desired_velocity:mag to 2.
        if slope < max_slope set desired_velocity to v(0, 0, 0).
        local delta_velocity is desired_velocity - velocity:surface.
        set target_vector to unrotate(up:vector * g() + delta_velocity).
        set t to hover(0).
        wait 0.
      }
    }

    function land {
      lock steering to descent_vector().
      until alt:radar < 15 {
        set t to hover(-descent_speed). wait 0.
      }
      until velocity:surface:mag < 0.5 { set t to hover(0). wait 0. }
      until ship:status = "Landed" { set t to hover(-contact_speed). wait 0. }
      lock throttle to 0.
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

  function descent_vector {
    if vang(srfretrograde:vector, up:vector) > 90 return unrotate(up).
    return unrotate(up:vector * g() - velocity:surface).
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

  export(suicide).
}
