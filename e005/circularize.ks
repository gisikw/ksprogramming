// Circularization Script v1.0.0
// Kevin Gisi
// http://youtube.com/gisikw

PARAMETER targetAltitude.
PARAMETER referenceVessel.
PARAMETER longitudeDifference.

// Wait for correct phase angle
IF referenceVessel <> FALSE {
  SET lngDiff TO 0.

  UNTIL lngDiff > longitudeDifference - 0.5 AND lngDiff < longitudeDifference + 0.5 {
    SET lngDiff TO SHIP:LONGITUDE - VESSEL(referenceVessel):LONGITUDE.
    WAIT 0.01.
  }
}

// Transfer burn
SET transfer TO PROGRADE.
LOCK STEERING TO transfer. WAIT 5.
LOCK THROTTLE TO 1.
WAIT UNTIL APOAPSIS > targetAltitude * 0.9.
LOCK THROTTLE TO 0.1.
WAIT UNTIL APOAPSIS > targetAltitude.
LOCK THROTTLE TO 0.

// Coast to apoapsis
WAIT UNTIL ETA:APOAPSIS < 20.

// Circularization burn
SET circularization TO PROGRADE.
LOCK STEERING TO circularization. WAIT 5.
LOCK THROTTLE TO 1.
WAIT UNTIL PERIAPSIS > targetAltitude * 0.9.
LOCK THROTTLE TO 0.1.
WAIT UNTIL PERIAPSIS > targetAltitude.
LOCK THROTTLE TO 0.
