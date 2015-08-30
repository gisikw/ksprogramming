// Mustachio Landing Script
// Kevin Gisi
// http://youtube.com/gisikw

NOTIFY("Beginning landing script").

RUN maneuver.ks.
RUN lib_pid.ks.
RUN telemetry.ks.

SET margin TO 100.
FUNCTION UPWARD {
  IF SHIP:VERTICALSPEED < 0 {
    RETURN SRFRETROGRADE.
  } ELSE {
    RETURN HEADING(90, 90).
  }
}

NOTIFY("Waiting to reach the Mun's sphere of influence").
WAIT UNTIL SHIP:BODY = MUN.
LOCK STEERING TO UPWARD(). WAIT 10.

NOTIFY("Waiting for 50km above the surface").
WAIT UNTIL ALT:RADAR < 50000.
LIGHTS ON. TOGGLE BRAKES.

LOCK THROTTLE TO 1.
WAIT UNTIL MNV_BURNOUT(TRUE).
LOCK THROTTLE TO 0.

GEAR OFF. WAIT 1. GEAR ON.

WAIT UNTIL TLM_TTI(margin) <= MNV_TIME(ABS(SHIP:VERTICALSPEED)).
NOTIFY("Beginning suicide burn").
LOCK THROTTLE TO 1.
WAIT UNTIL SHIP:VERTICALSPEED > -20.

NOTIFY("Entering controllable range. Enabling PID controller").

SET hoverPID TO PID_init(0.05, 0.005, 0.01, 0, 1).
SET pidThrottle TO 0.
LOCK THROTTLE TO pidThrottle.

SET targetDescent TO -20.

WHEN ALT:RADAR < 100 THEN {
  SET targetDescent TO -5.
  LOCK STEERING TO HEADING(90, 90).
}

WHEN ALT:RADAR < 20 THEN {
  SET targetDescent TO -2.
}

UNTIL SHIP:STATUS = "Landed" {
  SET pidThrottle TO PID_seek(hoverPID, targetDescent, SHIP:VERTICALSPEED).
  WAIT 0.001.
}

SET pidThrottle TO 0.
UNLOCK STEERING.

NOTIFY("Landed").
NOTIFY("Landing script complete").
