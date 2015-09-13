// BOSS Launch Script v1.0.0
// Kevin Gisi
// http://youtube.com/gisikw

IF SHIP:STATUS = "PRELAUNCH" {
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
  WAIT 1. STAGE.
  WAIT 1. TOGGLE PANELS. TOGGLE GEAR.

  WAIT UNTIL ETA:APOAPSIS < 20.
  NOTIFY("Boosting to transfer orbit").
  LOCK THROTTLE TO 1 - (0.999 * APOAPSIS/800000).
  UNTIL APOAPSIS > 800000 { MNV_BURNOUT(TRUE). WAIT 0.01. }
  LOCK THROTTLE TO 0.

  NOTIFY("Transfer orbit achieved").
  LOCK STEERING TO PROGRADE.
  WAIT UNTIL ETA:APOAPSIS < 20.
  LOCK THROTTLE TO 1 - (0.999 * SHIP:OBT:SEMIMAJORAXIS/(555675 + SHIP:OBT:BODY:RADIUS)).
  WAIT UNTIL SHIP:OBT:SEMIMAJORAXIS >= (555675 + SHIP:OBT:BODY:RADIUS).
  LOCK THROTTLE TO 0.
  NOTIFY("Launch orbit achieved").
}

IF SHIP:PARTSTITLED("KR-2042 b Scriptable Control System"):LENGTH > 0 {
  NOTIFY("Waiting an orbit...").
  WAIT UNTIL ETA:APOAPSIS > 30.
  WAIT UNTIL ETA:APOAPSIS < 20.
  NOTIFY("Releasing probe").
  STAGE.
}
