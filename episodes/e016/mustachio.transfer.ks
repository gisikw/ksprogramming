// Mustachio Transfer Script
// Kevin Gisi
// http://youtube.com/gisikw

NOTIFY("Beginning transfer script").

RUN orbit.ks.
RUN maneuver.ks.

SET transferHeight TO MUN:APOAPSIS.

FUNCTION ISH {
  PARAMETER a.
  PARAMETER b.
  PARAMETER ishyiness.

  RETURN a - ishyiness < b AND a + ishyiness > b.
}

// Wait for window
NOTIFY("Waiting for 111-degree angle from Mun").
UNTIL ISH(TARGET_ANGLE("Mun"), 111, 0.5) {
  PRINT TARGET_ANGLE("Mun").
  WAIT 0.001.
}

// Mun transfer
NOTIFY("Beginning transfer burn").
SET forward TO PROGRADE.
LOCK STEERING TO forward. WAIT 10.
LOCK THROTTLE TO 1 - (SHIP:APOAPSIS/transferHeight*0.99).
WAIT UNTIL SHIP:APOAPSIS > transferHeight.
LOCK THROTTLE TO 0.

// Enable antenna
NOTIFY("Enabling dish antenna").
SET p TO SHIP:PARTSTITLED("Reflectron KR-7")[0].
SET m TO p:GETMODULE("ModuleRTAntenna").
m:DOEVENT("Activate").
m:SETFIELD("target", "KeoSat1").

NOTIFY("Transfer script complete").
