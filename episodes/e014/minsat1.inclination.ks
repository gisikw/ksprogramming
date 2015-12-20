// MinSat1 Inclination Script
// Kevin Gisi
// http://youtube.com/gisikw

NOTIFY("Inclination script executing").
REQUIRE("maneuver.ks").

FUNCTION ISH {
  PARAMETER a.
  PARAMETER b.
  PARAMETER ishyiness.

  RETURN a - ishyiness < b AND a + ishyiness > b.
}

NOTIFY("Targetting Minmus").
SET TARGET TO MINMUS.
LOCK STEERING TO HEADING(180, 0).
WAIT 10.

NOTIFY("Adjusting inclination").
LOCK THROTTLE TO 1.
WAIT UNTIL (MINMUS:OBT:INCLINATION - SHIP:OBT:INCLINATION <= 0) OR MNV_BURNOUT(FALSE).
LOCK THROTTLE TO 0.

WAIT 5.
NOTIFY("Discarding stage").
STAGE.
