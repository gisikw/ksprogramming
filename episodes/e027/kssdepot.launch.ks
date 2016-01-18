// KSS Hab Launch Script v1.0.0
// Kevin Gisi
// http://youtube.com/gisikw

FUNCTION EXECUTE_ASCENT_STEP {
  PARAMETER direction.
  PARAMETER minAlt.
  PARAMETER newAngle.
  PARAMETER newThrust.

  SET prevThrust TO MAXTHRUST.

  UNTIL FALSE {

    IF MAXTHRUST < (prevThrust - 10) {
      WAIT 0.1. STAGE. WAIT 0.1.
      SET prevThrust TO MAXTHRUST.
    }

    IF ALTITUDE > minAlt {
      LOCK STEERING TO HEADING(direction, newAngle).
      LOCK THROTTLE TO newThrust.
      BREAK.
    }

    WAIT 0.1.
  }
}

FUNCTION EXECUTE_ASCENT_PROFILE {
  PARAMETER direction.
  PARAMETER profile.

  SET step TO 0.
  UNTIL step >= profile:length - 1 {
    EXECUTE_ASCENT_STEP(
      direction,
      profile[step],
      profile[step+1],
      profile[step+2]
    ).
    SET step TO step + 3.
  }
}

SET ascentProfile TO LIST(
  // Altitude,  Angle,  Thrust
  0,            85,     1,
  500,          80,     1,
  5000,         65,     1,
  10000,        55,     1,
  28000,        30,     1,
  45000,        0,      1
).

LOCK THROTTLE TO 1. WAIT 1. STAGE.
EXECUTE_ASCENT_PROFILE(90, ascentProfile).

WAIT UNTIL APOAPSIS > 80000.
LOCK THROTTLE TO 0. LOCK STEERING TO HEADING(90, 0).
WAIT UNTIL ETA:APOAPSIS < 30.
LOCK THROTTLE TO 1.
WAIT UNTIL PERIAPSIS > 75000.
LOCK THROTTLE TO 0.
WAIT 1.
STAGE.
