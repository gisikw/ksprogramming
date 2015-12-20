// Munsi Launch Script v1.0.0
// Kevin Gisi
// http://youtube.com/gisikw

DOWNLOAD("maneuver.ks").  RUN maneuver.ks.
DOWNLOAD("ascent.ks").    RUN ascent.ks.

SET ascentProfile TO LIST(
  // Altitude,  Angle,  Thrust
  0,            90,     1,
  500,          80,     1,
  10000,        75,     1,
  15000,        70,     1,
  20000,        65,     1,
  25000,        60,     1,
  32000,        50,     1,
  45000,        35,     1,
  50000,        25,     1,
  60000,        0,      1,
  70000,        0,      0
).

NOTIFY("Executing ascent").
LOCK THROTTLE TO 1. WAIT 1. STAGE.
EXECUTE_ASCENT_PROFILE(90, ascentProfile).

WAIT UNTIL ETA:APOAPSIS < 20.
LOCK THROTTLE TO 1.

UNTIL PERIAPSIS > 65000 { MNV_BURNOUT(TRUE). WAIT 0.01. }
LOCK THROTTLE TO 0. WAIT 1.
IF SHIP:LIQUIDFUEL > 270 { STAGE. WAIT 1. }

LOCK THROTTLE TO 1.
WAIT UNTIL PERIAPSIS > 70000.
LOCK THROTTLE TO 0.
NOTIFY("Orbit achieved").
