// Poodle Test Script v0.0.1

LOCK STEERING TO HEADING(90, 90).
STAGE.

SET conditions TO FALSE.

UNTIL conditions {
  IF (  SHIP:VERTICALSPEED > 300  AND
        SHIP:VERTICALSPEED < 900  AND
        ALTITUDE           > 5000 AND
        ALTITUDE           < 9000
     ) {
      SET conditions TO TRUE.
     }

  WAIT 0.01.
}

STAGE. // Contract!

WAIT UNTIL ALT:RADAR < 600.
STAGE.
