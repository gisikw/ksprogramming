// KeoSat1 Boost Script
// Kevin Gisi
// http://youtube.com/gisikw

REQUIRE("maneuver.ks").
REQUIRE("telemetry.ks").

NOTIFY("Transfer script executing").

// Calculate burn
SET dV TO MNV_HOHMANN_DV(2868470).
SET mnvTime TO MNV_TIME(dV[0]).
SET startTime TO TIME:SECONDS + ETA:PERIAPSIS - mnvTime / 2.

NOTIFY("Computed a " + dV[0] + " dv burn. It will take " + mnvTime + " seconds").
LOG "SET maneuverCompletion TO " + dV[1] + "." TO "storage.ks".
WAIT 5.

// Turn on the dish antenna
NOTIFY("Activating dish antenna").
SET p TO SHIP:PARTSTITLED("Comms DTS-M1")[0].
SET m to p:GETMODULE("ModuleRTAntenna").
m:DOEVENT("Activate").
m:SETFIELD("target", "Kerbin").

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

// Ensure solar panel visibility
LOCK STEERING TO HEADING(0,0).
WAIT 10.
