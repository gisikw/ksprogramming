// KeoSat1 Circularization Script
// Kevin Gisi
// http://youtube.com/gisikw

REQUIRE("maneuver.ks").

NOTIFY("Circularization script executing").
RUN storage.ks.

SET dV TO maneuverCompletion.
SET mnvTime to MNV_TIME(dV).
SET startTime TO TIME:SECONDS + ETA:APOAPSIS - mnvTime/2.

NOTIFY("Computed a " + dV + " dv burn. It will take " + mnvTime + " seconds").

// Lock steering ahead of time
WAIT UNTIL TIME:SECONDS > startTime - 10.
NOTIFY("Locking to prograde vector").
LOCK STEERING TO PROGRADE.

// Begin the burn
WAIT UNTIL TIME:SECONDS > startTime.
NOTIFY("Beginning transfer burn").
LOCK THROTTLE TO 1.

// End the burn
WAIT UNTIL TIME:SECONDS > startTime + mnvTime.
LOCK THROTTLE TO 0.
NOTIFY("Transfer burn complete").

// Align for sunlight
WAIT 5.
NOTIFY("Aligning craft for maximum sunlight").
LOCK STEERING TO HEADING(0, 0).
WAIT 5.

// Enable comm dish
NOTIFY("Activating remaining antennae").
SET p TO SHIP:PARTSTITLED("Comms DTS-M1")[1].
SET m TO p:GETMODULE("ModuleRTAntenna").
m:DOEVENT("Activate").
m:SETFIELD("target", "Mun").

// Enable reflectron
SET p TO SHIP:PARTSTITLED("Reflectron KR-7")[1].
SET m TO p:GETMODULE("ModuleRTAntenna").
m:DOEVENT("Activate").
m:SETFIELD("target", "active-vessel").
