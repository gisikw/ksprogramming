// Docker Test Script 2 v1.0.0
// Kevin Gisi
// http://youtube.com/gisikw

FUNCTION translate {
  PARAMETER vector.
  IF vector:MAG > 1 SET vector TO vector:normalized.

  SET SHIP:CONTROL:STARBOARD  TO vector * SHIP:FACING:STARVECTOR.
  SET SHIP:CONTROL:FORE       TO vector * SHIP:FACING:FOREVECTOR.
  SET SHIP:CONTROL:TOP        TO vector * SHIP:FACING:TOPVECTOR.
}

FUNCTION getTargetPort {
  LIST TARGETS IN targets.
  FOR target IN targets {
    IF target:DOCKINGPORTS:LENGTH <> 0 {
      IF target:DOCKINGPORTS[0]:TAG = "DockingPortB" {
        return target:DOCKINGPORTS[0].
      }
    }
  }
}

FUNCTION resetForTest {
  NOTIFY("Undocking").
  SHIP:DOCKINGPORTS[0]:UNDOCK().
  RCS ON.
  SET SHIP:CONTROL:FORE TO -1.
  WAIT 2.
  SET SHIP:CONTROL:FORE TO 0.
  RCS OFF.
  WAIT 10.
}

WAIT 10.
resetForTest().

SET dockingPort to SHIP:DOCKINGPORTS[0].
dockingPort:CONTROLFROM.

SET targetPort TO getTargetPort().

NOTIFY("Cancelling relative velocity").
RCS ON.
LOCK relativeVelocity TO SHIP:VELOCITY:ORBIT - targetPort:SHIP:VELOCITY:ORBIT.
UNTIL relativeVelocity:MAG < 0.1 {
  translate(-1 * relativeVelocity).
}
translate(V(0,0,0)).

NOTIFY("Aligning for docking").
LOCK STEERING TO -1 * targetPort:PORTFACING:VECTOR.

NOTIFY("Making Approach").
LOCK dockingVector TO targetPort:NODEPOSITION - dockingPort:NODEPOSITION + (targetPort:PORTFACING:VECTOR * 10).
SET start TO TIME:SECONDS.
UNTIL dockingPort:STATE <> "Ready" {
  translate(dockingVector:normalized - relativeVelocity).
  IF TIME:SECONDS - start > 120 {
    NOTIFY("Docking").
    LOCK dockingVector TO targetPort:NODEPOSITION - dockingPort:NODEPOSITION.
  }
  WAIT 0.01.
}

translate(V(0,0,0)).
RCS OFF.

NOTIFY("Done").
