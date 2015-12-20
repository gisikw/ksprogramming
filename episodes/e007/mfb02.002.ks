PRINT "Downloading important files".
DOWNLOAD("mfb02.startup.ks").
DOWNLOAD("orbit.ks").

RENAME "mfb02.startup.ks" TO "startup.ks".
RUN orbit.ks.

PRINT "Trying to go to the Mun!".

FUNCTION ISH {
  PARAMETER a.
  PARAMETER b.
  PARAMETER ishyiness.

  RETURN a - ishyiness < b AND a + ishyiness > b.
}

// Wait for window
UNTIL ISH(TARGET_ANGLE("Mun"), 135, 0.5) {
  PRINT TARGET_ANGLE("Mun").
  WAIT 0.001.
}

// Munar Transfer
SET forward TO PROGRADE.
LOCK STEERING TO forward.
WAIT 10.
LOCK THROTTLE TO 1.
WAIT UNTIL APOAPSIS > BODY("Mun"):APOAPSIS.
LOCK THROTTLE TO 0.
PRINT "We choose to go to the Mun".

// Wait until we're near the mun
WAIT UNTIL SHIP:OBT:BODY:NAME <> "Kerbin".
PRINT "Entered Mun's sphere of influence.".

// Put us in orbit
WAIT UNTIL ETA:PERIAPSIS < 20.
LOCK STEERING TO RETROGRADE.
WAIT 10.
LOCK THROTTLE TO 1.

WAIT UNTIL APOAPSIS > 0 AND APOAPSIS < (MUN:SOIRADIUS - MUN:RADIUS - 20000).
LOCK THROTTLE TO 0.
PRINT "We're in orbit!".
