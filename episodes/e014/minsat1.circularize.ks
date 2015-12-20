// MinSat1 Circularize Script
// Kevin Gisi
// http://youtube.com/gisikw

NOTIFY("Awaiting Minmus sphere of influence").
WAIT UNTIL SHIP:OBT:BODY = MINMUS.

NOTIFY("Entered Minmus's sphere of influence").
NOTIFY("Awaiting periapsis").
WAIT UNTIL ETA:PERIAPSIS < 20.

NOTIFY("Attempting circularization").
LOCK STEERING TO RETROGRADE.
WAIT 10.
LOCK THROTTLE TO 1.
WAIT UNTIL NOT SHIP:OBT:HASNEXTPATCH.
WAIT 1.
LOCK THROTTLE TO 0.

WAIT 5.
NOTIFY("Aligning craft for maximum sunlight").
LOCK STEERING TO HEADING(0,0).
WAIT 30.
