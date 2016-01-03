// Deep Space 1 Boot Script v1.0.0
// Kevin Gisi
// http://youtube.com/gisikw

set runmode to 0.
log "" to runmode.ks. run runmode.ks.

print "Booting".
print "Starting runmode: " + runmode.

function set_runmode {
  parameter n. set runmode to n.
  print "Runmode set to " + n.
  log "" to runmode.ks. delete runmode.ks.
  log "set runmode to " + n + "." to runmode.ks.
}

function antenna_on {
  set p TO ship:partstitled("Communotron 88-88")[0].
  set m TO p:getmodule("ModuleRTAntenna").
  m:doevent("Activate").
  m:setfield("target", "Receiver").
  wait 5.
}

function antenna_off {
  set p TO ship:partstitled("Communotron 88-88")[0].
  set m TO p:getmodule("ModuleRTAntenna").
  m:doevent("Deactivate").
  wait 5.
}

function repeatable_science {
  if addons:rt:hasconnection(ship) {
    for p in ship:parts if p:hasmodule("ModuleScienceExperiment") {
      set m to p:getmodule("ModuleScienceExperiment").
      if m:rerunnable and not m:inoperable {
        if m:hasdata { m:dump(). }
        m:deploy.
        set now to time:seconds.
        wait until m:hasdata or (time:seconds - now) > 2.
        if m:hasdata {
          m:transmit.
          wait 10.
        }
      }
    }
  }
}

until 0 {

  // Launch
  if runmode = 0 {
    wait 60.
    lock steering to up.
    lock throttle to 1.
    wait 1.
    stage.

    // Low atmosphere?
    wait 5.
    repeatable_science().

    // First stage
    set last_thrust to maxthrust.
    wait until last_thrust - maxthrust > 10.
    lock throttle to 0. wait 1.
    stage.
    lock throttle to 1.

    // Hopefully upper atmosphere?
    repeatable_science().

    wait until altitude > 72000.
    repeatable_science().

    // Second stage
    set last_thrust to maxthrust.
    wait until last_thrust - maxthrust > 10.
    lock throttle to 0. wait 1.
    stage.
    lock throttle to 1.

    set_runmode(1).
  }

  // Wait for out of SOI
  if runmode = 1 {
    // Orbit science and panels
    wait until altitude > 72000.
    panels on.

    // High above science
    wait until altitude > 260000.
    antenna_on().
    wait 5.
    repeatable_science().
    antenna_off().

    wait until ship:body = sun.
    wait 5.
    set_runmode(2).
  }

  // Waiting for connection
  if runmode = 2 {
    antenna_on().
    if addons:rt:hasconnection(ship) set_runmode(3).
    antenna_off().
  }

  // Doing science
  if runmode = 3 {
    for p in ship:parts if p:hasmodule("ModuleScienceExperiment") {
      set m to p:getmodule("ModuleScienceExperiment").
      if not m:inoperable {
        if m:hasdata { m:dump(). }
        m:deploy.
        set now to time:seconds.
        wait until m:hasdata or (time:seconds - now) > 2.
      }
    }
    set_runmode(4).
  }

  // Verify science
  if runmode = 4 {
    local data_parts is list().
    for p in ship:parts if p:hasmodule("ModuleScienceExperiment") {
      if p:getmodule("ModuleScienceExperiment"):hasdata {
        data_parts:add(p).
      }
    }

    for p in data_parts {
      antenna_on().
      set m to p:getmodule("ModuleScienceExperiment").
      m:transmit.
      wait 10.
      antenna_off().
    }

    if data_parts:length = 0 {
      set_runmode(5).
    }
  }

  if runmode = 5 {
    antenna_on().
    switch to 0.
    log "" to deepspace1.update.ks.
    run deepspace1.update.ks.
    switch to 1.
    antenna_off().
  }
}
