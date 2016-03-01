// KeoSat1 Launch Script v1.0.0
// Kevin Gisi
// http://youtube.com/gisikw

REQUIRE("maneuver.ks").

// Stage 1 launch
LOCK THROTTLE TO 0.
LOCK STEERING TO HEADING(90, 85).
STAGE.

WAIT UNTIL MNV_BURNOUT(FALSE).
LOCK THROTTLE TO 1.
STAGE. WAIT 2.
LOCK STEERING TO HEADING(90, 45).

// Pitch toward the horizon
WAIT UNTIL APOAPSIS > 60000.
LOCK STEERING TO HEADING(90, 10).

// Wait until we're going to space
WAIT UNTIL APOAPSIS > 80000.
LOCK THROTTLE TO 0.

// Coast to apoapsis, then circularize
WAIT UNTIL ETA:APOAPSIS < 20.
LOCK STEERING TO HEADING(90, 0).
LOCK THROTTLE TO 1.

// Wait for orbit, staging as needed
UNTIL PERIAPSIS > 60000 {
  MNV_BURNOUT(TRUE).
  WAIT 0.01.
}
LOCK THROTTLE TO 0.

// Stage, and complete circularization
WAIT 1. STAGE. WAIT 1.
LOCK THROTTLE TO 1.
WAIT UNTIL PERIAPSIS > 70000.
LOCK THROTTLE TO 0.

// Enable antenna
SET omnis TO SHIP:PARTSNAMED("longAntenna").
FOR omni IN omnis {
  omni:GETMODULE("ModuleRTAntenna"):DOEVENT("Activate").
}
