// PID Test v1.0.0
// Kevin Gisi
// http://youtube.com/gisikw

SET kP TO 0.01.
SET kI TO 0.005.
SET kD TO 0.005.

SET lastP TO 0.
SET lastTime TO 0.
SET totalP TO 0.

FUNCTION PID_LOOP {
  PARAMETER target.
  PARAMETER current.

  SET output TO 0.
  SET now TO TIME:SECONDS.

  SET P TO target - current.
  SET I TO 0.
  SET D TO 0.

  IF lastTime > 0 {
    SET I TO totalP + ((P + lastP)/2 * (now - lastTime)).
    SET D TO (P - lastP) / (now - lastTime).
  }

  SET output TO P * kP + I * kI + D * kD.

  CLEARSCREEN.
  PRINT "P: " + P.
  PRINT "I: " + I.
  PRINT "D: " + D.
  PRINT "Output: " + output.

  SET lastP TO P.
  SET lastTime TO now.
  SET totalP TO I.

  RETURN output.
}

// Get us 500 meters up
LOCK STEERING TO HEADING(90, 90).
LOCK THROTTLE TO 0.2.
STAGE.
WAIT UNTIL ALTITUDE > 500.

// Test our proportional function
SET autoThrottle TO 0.
LOCK THROTTLE TO autoThrottle.

SWITCH TO 0.
SET startTime TO TIME:SECONDS.

UNTIL STAGE:LIQUIDFUEL < 10 {
  SET autoThrottle TO PID_LOOP(500, ALTITUDE).
  SET autoThrottle TO MAX(0, MIN(autoThrottle, 1)).
  WAIT 0.001.
  LOG (TIME:SECONDS - startTime) + "," + ALTITUDE + "," + autoThrottle TO "testflight.csv".
}

// Recover the vessel
LOCK THROTTLE TO 0.
STAGE.
SWITCH TO 1.
