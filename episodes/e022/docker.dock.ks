// Docker Dock Script v1.0.0
// Kevin Gisi
// http://youtube.com/gisikw


FUNCTION translate {
  PARAMETER vector.
  SET vector TO vector:normalized.

  SET SHIP:CONTROL:STARBOARD  TO vector * SHIP:FACING:STARVECTOR.
  SET SHIP:CONTROL:FORE       TO vector * SHIP:FACING:FOREVECTOR.
  SET SHIP:CONTROL:TOP        TO vector * SHIP:FACING:TOPVECTOR.
}

WAIT 10.
STAGE.
WAIT 10.

LIST DOCKINGPORTS IN dockingPorts.
SET dockingPort to dockingPorts[0].
dockingPort:CONTROLFROM.

SET targetPort TO false.

LIST TARGETS IN targets.
FOR target in targets {
  IF target:DOCKINGPORTS:LENGTH <> 0 {
    IF target:DOCKINGPORTS[0]:TAG = "DockingPortB" {
      SET targetPort TO target:DOCKINGPORTS[0].
    }
  }
}

PRINT "Cancelling relative velocity".
RCS ON.
LOCK relativeVelocity TO SHIP:VELOCITY:ORBIT - targetPort:SHIP:VELOCITY:ORBIT.
UNTIL relativeVelocity:MAG < 0.1 {
  translate(-1 * relativeVelocity).
}
translate(V(0,0,0)).

PRINT "Aligning for docking".
LOCK STEERING TO -1 * targetPort:PORTFACING:VECTOR.

PRINT "Docking".
LOCK dockingVector TO targetPort:NODEPOSITION - dockingPort:NODEPOSITION.
UNTIL dockingPort:STATE <> "Ready" {
  translate(dockingVector:normalized - relativeVelocity).
}

translate(V(0,0,0)).
RCS OFF.

PRINT "Done".
