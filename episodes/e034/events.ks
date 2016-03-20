// +-----------------------+ //
// | Version 1: Interrupts | //
// +-----------------------+ //

print "Launching!".
lock steering to heading(90, 90).
lock throttle to 1.
stage.

when altitude > 30000 then {
  lock steering to heading(90, 65).
}

function foo {
  local bar is 5.
  when altitude > 70000 then {
    print bar.
    panels on.
    lock throttle to 0.
  }
}

when ship:electriccharge < 10 or done then {
  if not done {
    disable_antennas().
    preserve.
  }
}
