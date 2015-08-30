// KeoSat1 Adjustment Script
// Kevin Gisi
// http://youtube.com/gisikw

NOTIFY("Performing minor adjustments").

// Enable reflectron
SET p TO SHIP:PARTSTITLED("Reflectron KR-7")[0].
SET m TO p:GETMODULE("ModuleRTAntenna").
m:DOEVENT("Activate").
m:SETFIELD("target", "active-vessel").

// Finalize orbital period
LOCK STEERING TO RETROGRADE.
WAIT 10.
LOCK THROTTLE TO 0.01.
WAIT UNTIL SHIP:OBT:PERIOD <= 21600.
LOCK THROTTLE TO 0.

// Align for sunlight
LOCK STEERING TO HEADING(0,0).
WAIT 60.
