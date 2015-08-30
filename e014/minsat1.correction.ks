// MinSat1 Correction Script
// Kevin Gisi
// http://youtube.com/gisikw

NOTIFY("Performing correction").

LOCK STEERING TO RETROGRADE.
WAIT 10.
SET startTime TO TIME:SECONDS.
LOCK THROTTLE TO 0.01.
WAIT UNTIL SHIP:OBT:HASNEXTPATCH OR TIME:SECONDS > startTime + 30.
LOCK THROTTLE TO 0.

WAIT 5.
NOTIFY("Aligning craft for maximum sunlight").
LOCK STEERING TO HEADING(0,0).
WAIT 30.
