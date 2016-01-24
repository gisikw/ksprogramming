// Ascent Test #2
// Kevin Gisi
// http://youtube.com/gisikw

print "Toggle RCS to launch".
wait until rcs.

lock throttle to 1.
lock steering to heading(90, 90).
stage.

wait 5.

// Force a constant thrust-to-weight ratio
lock g to body:mu / ((ship:altitude + body:radius)^2).
lock maxtwr to ship:maxthrust / (g * ship:mass).
lock throttle to min(1.3 / maxtwr, 1).

// Linearly decrease pitch based on desired altitude
lock pitch to 90 - ((alt:radar / 100000) * 90).
lock steering to heading(90, pitch).

until 0 { wait 60. }
