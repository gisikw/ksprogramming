// Munsi3 "Autopilot"
// Kevin Gisi
// http://youtube.com/gisikw

RUN maneuver.ks.

NOTIFY("Maneuver autopilot initiated").
NOTIFY("RCS: Execute Maneuver. Brakes: Done").

SET done to FALSE.
ON BRAKES  { SET done to TRUE. }

SET rcsState TO RCS.
UNTIL done {
  IF RCS <> rcsState {
    SET rcsState TO RCS.
    NOTIFY("Executing maneuver...").
    MNV_EXEC_NODE(TRUE).
    NOTIFY("Done").
  }
  WAIT 0.1.
}

NOTIFY("Maneuver autopilot terminated").
