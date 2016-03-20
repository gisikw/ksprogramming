// +---------------------------+ //
// | Version 3: Fancy Runmodes | //
// +---------------------------+ //

set LAUNCH to 1.
set GRAVITY_TURN to 2.
set MAIN_ENGINE_CUTOFF to 3.

// Persist runmode to disk
set runmode to 0.
function set_runmode {
  parameter mode.
  writejson(list(mode), "runmode.json").
  set runmode to mode.
}

// Recover runmode or use default
if core:volume:files:haskey("runmode.json") {
  set runmode to readjson("runmode.json")[0].
} else {
  set_runmode(LAUNCH).
}

until 0 {

  if runmode = LAUNCH {

    print "Launching!".
    lock steering to heading(90, 90).
    lock throttle to 1.
    stage.
    set_runmode(GRAVITY_TURN).

  } else if runmode = GRAVITY_TURN {

    if altitude > 30000 {
      lock steering to heading(90, 65).
      set_runmode(MAIN_ENGINE_CUTOFF).
    }

  } else if runmode = MAIN_ENGINE_CUTOFF {

    if altitude > 70000 {
      panels on.
      lock throttle to 0.
      set_runmode(0).
    }

  }

  if ship:electriccharge < 10 disable_antennas().
  wait 0.01.
}
