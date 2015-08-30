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
LOCK STEERING TO HEADING(90, 75).

WAIT 10.
LOCK STEERING TO HEADING(90, 65).

WAIT 10.
LOCK STEERING TO HEADING(90, 55).

WAIT 10.
LOCK STEERING TO HEADING(90, 45).

// Pitch toward the horizon
UNTIL APOAPSIS > 60000 {
  MNV_BURNOUT(TRUE).
  WAIT 0.01.
}
LOCK STEERING TO HEADING(90, 10).

// Wait until we're going to space
UNTIL APOAPSIS > 80000 {
  MNV_BURNOUT(TRUE).
  WAIT 0.01.
}
LOCK THROTTLE TO 0.

// Coast to apoapsis, then circularize
WAIT UNTIL ETA:APOAPSIS < 20.
LOCK STEERING TO HEADING(90, 0).
LOCK THROTTLE TO 1.

// Wait for orbit, staging as needed
UNTIL PERIAPSIS > 70000 {
  MNV_BURNOUT(TRUE).
  WAIT 0.01.
}
LOCK THROTTLE TO 0.

// Enable antenna
SET p TO SHIP:PARTSTITLED("Communotron 16")[0].
SET m TO p:GETMODULE("ModuleRTAntenna").
m:DOEVENT("Activate").
m:SETFIELD("target", "active-vessel").
