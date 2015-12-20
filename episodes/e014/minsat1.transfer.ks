// MinSat1 Transfer Script
// Kevin Gisi
// http://youtube.com/gisikw

REQUIRE("orbit.ks").
REQUIRE("maneuver.ks").

FUNCTION ISH {
  PARAMETER a.
  PARAMETER b.
  PARAMETER ishyiness.

  RETURN a - ishyiness < b AND a + ishyiness > b.
}

// Wait for window
NOTIFY("Waiting for 115-degree angle from Minmus").
UNTIL ISH(TARGET_ANGLE("Minmus"), 115, 0.5) {
  PRINT TARGET_ANGLE("Minmus").
  WAIT 0.001.
}

// Minmus transfer
NOTIFY("Beginning transfer burn").
SET forward TO PROGRADE.
LOCK STEERING TO forward.
WAIT 10.
LOCK THROTTLE TO 1.
WAIT UNTIL SHIP:APOAPSIS > MINMUS:APOAPSIS.
LOCK THROTTLE TO 0.

// Enable antenna
NOTIFY("Enabling dish antenna").
SET p TO SHIP:PARTSTITLED("Reflectron KR-7")[0].
SET m TO p:GETMODULE("ModuleRTAntenna").
m:DOEVENT("Activate").
m:SETFIELD("target", "KeoSat1").

WAIT 5.
NOTIFY("Aligning craft for maximum sunlight").
LOCK STEERING TO HEADING(0,0).
WAIT 30.
