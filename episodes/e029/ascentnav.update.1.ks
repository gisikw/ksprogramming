// Ascent Test #1
// Kevin Gisi
// http://youtube.com/gisikw

print "Toggle RCS to launch".
wait until rcs.
copy maneuver.ks from 0. run maneuver.ks.
copy ascent.ks from 0.   run ascent.ks.

set ascentprofile to list(
  // altitude,  angle,  thrust
  0,            90,     1,
  500,          80,     1,
  10000,        75,     1,
  15000,        70,     1,
  20000,        65,     1,
  25000,        60,     1,
  32000,        50,     1,
  45000,        35,     1,
  50000,        25,     1,
  60000,        0,      1,
  70000,        0,      0
).

lock throttle to 1. wait 1. stage.
execute_ascent_profile(90, ascentprofile).

wait until eta:apoapsis < 20.
lock throttle to 1.
wait until periapsis > 70000.
lock throttle to 0.
