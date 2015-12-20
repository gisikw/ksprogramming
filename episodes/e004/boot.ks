// OmniSat Boot v1.0.0
// Kevin Gisi
// http://youtube.com/gisikw

IF ALT:RADAR < 100 {

  COPY exec.ascent.profile.ks FROM 0.
  RUN exec.ascent.profile.ks.

  SET ASCENT_PROFILE TO LIST(
    // Altitude,  Angle,  Thrust
    0,            80,     1,
    2500,         80,     0.35,
    10000,        75,     0.35,
    15000,        70,     0.35,
    20000,        65,     0.35,
    25000,        60,     0.35,
    32000,        50,     0.35,
    45000,        35,     0.1,
    50000,        25,     0.1,
    60000,        0,      0.1,
    70000,        0,      1,
    72000,        0,      0
  ).

  LOCK THROTTLE TO 1. WAIT 1. STAGE.
  EXECUTE_ASCENT_PROFILE(90, ASCENT_PROFILE).

  // Start circularization
  WAIT UNTIL ETA:APOAPSIS < 20.
  LOCK THROTTLE TO 0.75.

  // Pause circularization and ditch drive section
  WAIT UNTIL PERIAPSIS > 50000.
  LOCK THROTTLE TO 0. WAIT 1. STAGE.

  // Complete circularization
  WAIT 10. LOCK THROTTLE TO 1.
  WAIT UNTIL PERIAPSIS > 70000.

  // Enable Communitron and shutdown
  TOGGLE LIGHTS.
  LOCK THROTTLE TO 0.
  SET SHIP:CONTROL:PILOTMAINTHROTTLE TO 0.
}
