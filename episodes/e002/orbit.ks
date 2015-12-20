// Orbit v1.0.0
// Kevin Gisi
// http://youtube.com/gisikw

// Note: Thermometer is bound to the LIGHTS action group.

TOGGLE LIGHTS.
PRINT "Launching in 5s...".
LOCK THROTTLE to 0.9.
LOCK STEERING TO HEADING(90, 90).
WAIT 5.

PRINT "Launching!".
STAGE.
WAIT 1. TOGGLE LIGHTS.

WAIT UNTIL STAGE:SOLIDFUEL < 0.1.
WAIT 0.1.
PRINT "Discarding boosters.".
STAGE.

WAIT UNTIL ALTITUDE > 30000. TOGGLE LIGHTS.
WAIT UNTIL ALTITUDE > 70000. TOGGLE LIGHTS.

WAIT UNTIL ALT:RADAR < 500. STAGE.

// NOTE: This line doesn't work (though it was what was used in the video). The
// altimeter is based on the center of the craft, so the program never detects
// that the vessel has landed. Instead, try the following:
// WAIT UNTIL ALT:RADAR < 10. WAIT 5. TOGGLE LIGHTS.
WAIT UNTIL ALT:RADAR < 1. WAIT 1. TOGGLE LIGHTS.
