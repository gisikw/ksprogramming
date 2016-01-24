// Ascent Test #3
// Kevin Gisi
// http://youtube.com/gisikw

print "Toggle RCS to launch".
wait until rcs.

lock throttle to 1.
lock steering to heading(90, 90).
stage.

wait 5.

// Scale pitch by the square root of our target
lock pitch to 90 - ((alt:radar / 100000)^0.5 * 90).
lock steering to heading(90, pitch).

until 0 { wait 1. }
