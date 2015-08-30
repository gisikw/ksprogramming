// Mustachio Hover Test
// Kevin Gisi
// http://youtube.com/gisikw

REQUIRE("lib_pid.ks").

LIGHTS ON.
GEAR OFF. GEAR ON.
LOCK STEERING TO HEADING(90, 90).

NOTIFY("Running Mustachio hoverscript").

SET pidThrottle TO 0.
SET shouldHover TO TRUE.
SET landedAlt   TO ALT:RADAR.

LOCK THROTTLE TO pidThrottle.
STAGE.

SET hoverPID TO PID_INIT(0.05, 0.01, 0.1, 0, 1).

WHEN ALT:RADAR > landedAlt + 5 THEN { GEAR OFF. }
WHEN STAGE:LIQUIDFUEL < 10 THEN { SET shouldHover TO FALSE. }
UNTIL NOT shouldHover {
  SET pidThrottle TO PID_SEEK(hoverPID, landedAlt + 10, ALT:RADAR).
  WAIT 0.001.
}

NOTIFY("Beginning descent").
GEAR ON.

UNTIL SHIP:STATUS = "Landed" {
  SET pidThrottle TO PID_SEEK(hoverPID, landedAlt, ALT:RADAR).
  WAIT 0.001.
}

SET pidThrottle TO 0.
NOTIFY("Test complete").
