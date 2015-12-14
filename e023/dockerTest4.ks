// Docker Test Script 4 v1.0.0
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

FUNCTION approach_port {
  PARAMETER targetPort, dockingPort, distance, speed.

  dockingPort:CONTROLFROM().

  LOCK distanceOffset TO targetPort:PORTFACING:VECTOR * distance.
  LOCK approachVector TO targetPort:NODEPOSITION - dockingPort:NODEPOSITION + distanceOffset.
  LOCK relativeVelocity TO SHIP:VELOCITY:ORBIT - targetPort:SHIP:VELOCITY:ORBIT.
  LOCK STEERING TO -1 * targetPort:PORTFACING:VECTOR.

  UNTIL dockingPort:STATE <> "Ready" {
    translate((approachVector:normalized * speed) - relativeVelocity).
    LOCAL distanceVector IS (targetPort:NODEPOSITION - dockingPort:NODEPOSITION).
    IF VANG(dockingPort:PORTFACING:VECTOR, distanceVector) < 2 AND abs(distance - distanceVector:MAG) < 0.1 {
      BREAK.
    }
    WAIT 0.01.
  }

  translate(V(0,0,0)).
}

FUNCTION ensure_range {
  PARAMETER targetPort, dockingPort, distance, speed.

  LOCK relativePosition TO SHIP:POSITION - targetPort:SHIP:POSITION.
  LOCK departVector TO (relativePosition:normalized * distance) - relativePosition.
  LOCK relativeVelocity TO SHIP:VELOCITY:ORBIT - targetPort:SHIP:VELOCITY:ORBIT.
  LOCK STEERING TO -1 * targetPort:PORTFACING:VECTOR.

  UNTIL FALSE {
    translate((departVector:normalized * speed) - relativeVelocity).
    IF departVector:MAG < 0.1 BREAK.
    WAIT 0.01.
  }

  translate(V(0,0,0)).
}

FUNCTION sideswipe_port {
  PARAMETER targetPort, dockingPort, distance, speed.

  dockingPort:CONTROLFROM().

  LOCK sideDirection TO targetPort:SHIP:FACING:STARVECTOR.
  IF abs(sideDirection * targetPort:PORTFACING:VECTOR) = 1 {
    LOCK sideDirection TO targetPort:SHIP:FACING:TOPVECTOR.
  }

  LOCK distanceOffset TO sideDirection * distance.
  LOCK approachVector TO targetPort:NODEPOSITION - dockingPort:NODEPOSITION + distanceOffset.
  LOCK relativeVelocity TO SHIP:VELOCITY:ORBIT - targetPort:SHIP:VELOCITY:ORBIT.
  LOCK STEERING TO -1 * targetPort:PORTFACING:VECTOR.

  UNTIL FALSE {
    translate((approachVector:normalized * speed) - relativeVelocity).
    IF approachVector:MAG < 0.1 BREAK.
    WAIT 0.01.
  }

  translate(V(0,0,0)).
}

FUNCTION kill_relative_velocity {
  PARAMETER targetPort.

  LOCK relativeVelocity TO SHIP:VELOCITY:ORBIT - targetPort:SHIP:VELOCITY:ORBIT.
  UNTIL relativeVelocity:MAG < 0.1 {
    translate(-relativeVelocity).
  }
  translate(V(0,0,0)).
}

WAIT 10.
resetForTest().

SET dockingPort to SHIP:DOCKINGPORTS[0].
SET targetPort TO getTargetPort().

RCS ON.
NOTIFY("Ensuring range").
ensure_range(targetPort, dockingPort, 100, 5).
NOTIFY("Cancelling relative velocity").
kill_relative_velocity(targetPort).
NOTIFY("Making sideswipe maneuver").
sideswipe_port(targetPort, dockingPort, 100, 5).
NOTIFY("Making 100m Approach").
approach_port(targetPort, dockingPort, 100, 5).
NOTIFY("Making 50m Approach").
approach_port(targetPort, dockingPort, 50, 3).
NOTIFY("Making 20m Approach").
approach_port(targetPort, dockingPort, 20, 2).
NOTIFY("Making 10m Approach").
approach_port(targetPort, dockingPort, 10, 1).
NOTIFY("Making Final Approach").
approach_port(targetPort, dockingPort, 0, 0.5).
RCS OFF.

NOTIFY("Done").
