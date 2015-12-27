// KSS Hab Launch Script v1.0.0
// Kevin Gisi
// http://youtube.com/gisikw

DOWNLOAD("maneuver.ks"). RUN maneuver.ks.
DOWNLOAD("ascent.ks").   RUN ascent.ks.

SET ascentProfile TO LIST(
  // Altitude,  Angle,  Thrust
  0,            90,     1,
  500,          80,     1,
  10000,        75,     1,
  15000,        70,     1,
  20000,        65,     1,
  25000,        55,     1,
  32000,        45,     1,
  38000,        30,     1,
  45000,        25,     1,
  50000,        15,     1,
  60000,        0,      1,
  70000,        0,      0
).

LOCK THROTTLE TO 1. WAIT 1. STAGE.
EXECUTE_ASCENT_PROFILE(90, ascentProfile).

WAIT UNTIL ETA:APOAPSIS < 100.
LOCK THROTTLE TO 1.

UNTIL PERIAPSIS > 65000 { MNV_BURNOUT(TRUE). WAIT 0.01. }
LOCK THROTTLE TO 0. WAIT 1.

PRINT TIME:SECONDS + ": Ditching main engine".
STAGE. WAIT 10.

PRINT TIME:SECONDS + ": Boosting to 80km periapsis".
LOCK THROTTLE TO 1.
WAIT UNTIL PERIAPSIS > 80000.
LOCK THROTTLE TO 0.

PRINT TIME:SECONDS + ": Deploying things".
TOGGLE GEAR. TOGGLE PANELS.
