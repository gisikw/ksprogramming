PRINT "LOADING LAUNCH SCRIPT".
DOWNLOAD("ascent.ks").
RUN ascent.ks.

SET ASCENT_PROFILE TO LIST(
  // Altitude,  Angle,  Thrust
  0,            80,     1,
  1500,         80,     0.35,
  10000,        75,     0.35,
  12000,        70,     0.35,
  15000,        65,     0.35,
  20000,        60,     0.5,
  25000,        55,     0.5,
  32000,        45,     0.5,
  45000,        35,     0.1,
  50000,        25,     0.1,
  60000,        0,      0.1,
  70000,        0,      0
).

LOCK THROTTLE TO 1. WAIT 1. STAGE.
EXECUTE_ASCENT_PROFILE(90, ASCENT_PROFILE).

TOGGLE GEAR. // Switch communications
WAIT UNTIL ETA:APOAPSIS < 30.
LOCK STEERING TO HEADING(90, 0).
LOCK THROTTLE TO 1.

SET prevThrust TO MAXTHRUST.
UNTIL FALSE {

  IF MAXTHRUST < (prevThrust - 10) {
    LOCK THROTTLE TO 0.
    WAIT 1. STAGE. WAIT 1.
    LOCK THROTTLE TO 1.
    SET prevThrust TO MAXTHRUST.
  }

  IF PERIAPSIS > 70000 {
    BREAK.
  }
}

LOCK THROTTLE TO 0.
PRINT "Step executed. Shutting down.".
