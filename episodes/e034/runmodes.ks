// +---------------------+ //
// | Version 2: Runmodes | //
// +---------------------+ //

set runmode to 1.

until 0 {
  if runmode = 1 {
    print "Launching!".
    lock steering to heading(90, 90).
    lock throttle to 1.
    stage.
    set runmode to 2.
  } else if runmode = 2 {
    if altitude > 30000 {
      lock steering to heading(90, 65).
      set runmode to 3.
    }
  } else if runmode = 3 {
    if altitude > 70000 {
      panels on.
      lock throttle to 0.
      set runmode to 0.
    }
  }

  if ship:electriccharge < 10 {
    disable_antennas().
  }

  wait 0.01.
}
