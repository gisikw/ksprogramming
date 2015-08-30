// Mustachio Suicide Burn Test
// Kevin Gisi
// http://youtube.com/gisikw

// Dependencies
DOWNLOAD("telemetry.ks"). RUN telemetry.ks.
DOWNLOAD("maneuver.ks").  RUN maneuver.ks.
DOWNLOAD("lib_pid.ks").   RUN lib_pid.ks.

// Set variables
GEAR OFF.
SET safetyMargin TO 100.
SET targetDescent TO -5.
SET hoverPID TO PID_init(0.05, 0.005, 0.01, 0, 1).
SET pidThrottle TO 0.
NOTIFY("Beginning suicide burn test").

// Get to testing range
LOCK STEERING TO HEADING(90, 90).
STAGE.
WAIT UNTIL MNV_BURNOUT(TRUE).
WAIT UNTIL SHIP:VERTICALSPEED < 0.
NOTIFY("Waiting for suicide burn time").

// Suicide burn
WAIT UNTIL TLM_TTI(safetyMargin) <= MNV_TIME(-SHIP:VERTICALSPEED).
NOTIFY("Beginning suicide burn").
LOCK THROTTLE TO 1.
WAIT UNTIL SHIP:VERTICALSPEED > -5.

NOTIFY("Entering controllable range. Enabling PID controller").

// PID
GEAR ON.
LOCK THROTTLE TO pidThrottle.

UNTIL SHIP:STATUS = "Landed" {
  SET pidThrottle TO PID_seek(hoverPID, targetDescent, SHIP:VERTICALSPEED).
  WAIT 0.001.
}

SET pidThrottle TO 0.
NOTIFY("Done").
