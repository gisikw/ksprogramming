{
  local INFINITY is 2^64.

  local transfer is lex(
    "exec", exec@,
    "freeze", freeze@,
    "seek_SOI", seek_SOI@,
    "seek", seek@
  ).

  function freeze {
    parameter n. return lex("frozen", n).
  }

  function seek {
    parameter t, r, n, p, fitness,
              data is list(t, r, n, p),
              fit is orbit_fitness(fitness@).
    set data to optimize(data, fit, 100).
    set data to optimize(data, fit, 10).
    set data to optimize(data, fit, 1).
    fit(data). wait 0. return data.
  }

  function seek_SOI {
    parameter target_body, target_periapsis,
              start_time is time:seconds + 600.
    local data is seek(start_time, 0, 0, 0, {
      parameter mnv.
      if transfers_to(mnv:orbit, target_body) return 1.
      return -closest_approach(
                target_body,
                time:seconds + mnv:eta,
                time:seconds + mnv:eta + mnv:orbit:period).
    }).
    return seek(data[0], data[1], data[2], data[3], {
      parameter mnv.
      if not transfers_to(mnv:orbit, target_body) return -INFINITY.
      return -abs(mnv:orbit:nextpatch:periapsis - target_periapsis).
    }).
  }

  function transfers_to {
    parameter target_orbit, target_body.
    return (target_orbit:hasnextpatch and
            target_orbit:nextpatch:body = target_body).
  }

  function closest_approach {
    parameter target_body, start_time, end_time.
    local start_slope is slope_at(target_body, start_time).
    local end_slope is slope_at(target_body, end_time).
    local middle_time is (start_time + end_time) / 2.
    local middle_slope is slope_at(target_body, middle_time).
    until (end_time - start_time < 0.1) or middle_slope < 0.1 {
      if (middle_slope * start_slope) > 0
        set start_time to middle_time.
      else
        set end_time to middle_time.
      set middle_time to (start_time + end_time) / 2.
      set middle_slope to slope_at(target_body, middle_time).
    }
    return separation_at(target_body, middle_time).
  }

  function slope_at {
    parameter target_body, at_time.
    return (
      separation_at(target_body, at_time + 1) -
      separation_at(target_body, at_time - 1)
    ) / 2.
  }

  function separation_at {
    parameter target_body, at_time.
    return (positionat(ship, at_time) - positionat(target_body, at_time)):mag.
  }

  function exec {
    parameter autowarp is 0, n is nextnode,
              v is n:burnvector,
              starttime is time:seconds + n:eta - mnv_time(v:mag)/2.
    lock steering to n:burnvector.
    if autowarp warpto(starttime - 30).
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
    wait 0.
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

  function orbit_fitness {
    parameter fitness.
    return {
      parameter data.
      until not hasnode { remove nextnode. wait 0. }
      local new_node is node(
        unfreeze(data[0]), unfreeze(data[1]),
        unfreeze(data[2]), unfreeze(data[3])).
      add new_node.
      wait 0.
      return fitness(new_node).
    }.
  }

  function optimize {
    parameter data, fitness, step_size,
              winning is list(fitness(data), data),
              improvement is best_neighbor(winning, fitness, step_size).
    until improvement[0] <= winning[0] {
      set winning to improvement.
      set improvement to best_neighbor(winning, fitness, step_size).
    }
    return winning[1].
  }

  function best_neighbor {
    parameter best, fitness, step_size.
    for neighbor in neighbors(best[1], step_size) {
      local score is fitness(neighbor).
      if score > best[0] set best to list(score, neighbor).
    }
    return best.
  }

  function neighbors {
    parameter data, step_size, results is list().
    for i in range(0, data:length) if not frozen(data[i]) {
      local increment is data:copy.
      local decrement is data:copy.
      set increment[i] to increment[i] + step_size.
      set decrement[i] to decrement[i] - step_size.
      results:add(increment).
      results:add(decrement).
    }
    return results.
  }

  function frozen {
    parameter v. return (v+""):indexof("frozen") <> -1.
  }

  function unfreeze {
    parameter v. if frozen(v) return v["frozen"]. else return v.
  }

  export(transfer).
}
