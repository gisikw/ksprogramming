// Docking Library v1.0.0
// Kevin Gisi
// http://youtube.com/gisikw

FUNCTION dok_translate {
  PARAMETER vector.
  IF vector:MAG > 1 SET vector TO vector:normalized.

  SET SHIP:CONTROL:STARBOARD  TO vector * SHIP:FACING:STARVECTOR.
  SET SHIP:CONTROL:FORE       TO vector * SHIP:FACING:FOREVECTOR.
  SET SHIP:CONTROL:TOP        TO vector * SHIP:FACING:TOPVECTOR.
}

FUNCTION dok_get_port {
  PARAMETER name.
  LIST TARGETS IN targets.
  targets:add(SHIP).
  FOR target IN targets {
    IF target:DOCKINGPORTS:LENGTH <> 0 {
      FOR port IN target:DOCKINGPORTS {
        IF port:TAG = name RETURN port.
      }
    }
  }
}

FUNCTION dok_approach_port {
  PARAMETER targetPort, dockingPort, distance, speed.

  dockingPort:CONTROLFROM().

  LOCK distanceOffset TO targetPort:PORTFACING:VECTOR * distance.
  LOCK approachVector TO targetPort:NODEPOSITION - dockingPort:NODEPOSITION + distanceOffset.
  LOCK relativeVelocity TO SHIP:VELOCITY:ORBIT - targetPort:SHIP:VELOCITY:ORBIT.
  LOCK STEERING TO LOOKDIRUP(-targetPort:PORTFACING:VECTOR, targetPort:PORTFACING:UPVECTOR).

  UNTIL dockingPort:STATE <> "Ready" {
    dok_translate((approachVector:normalized * speed) - relativeVelocity).
    LOCAL distanceVector IS (targetPort:NODEPOSITION - dockingPort:NODEPOSITION).
    IF VANG(dockingPort:PORTFACING:VECTOR, distanceVector) < 2 AND abs(distance - distanceVector:MAG) < 0.1 {
      BREAK.
    }
    WAIT 0.01.
  }

  dok_translate(V(0,0,0)).
}

FUNCTION dok_ensure_range {
  PARAMETER targetVessel, dockingPort, distance, speed.

  LOCK relativePosition TO SHIP:POSITION - targetVessel:POSITION.
  LOCK departVector TO (relativePosition:normalized * distance) - relativePosition.
  LOCK relativeVelocity TO SHIP:VELOCITY:ORBIT - targetVessel:VELOCITY:ORBIT.
  LOCK STEERING TO HEADING(0,0).

  UNTIL FALSE {
    dok_translate((departVector:normalized * speed) - relativeVelocity).
    IF departVector:MAG < 0.1 BREAK.
    WAIT 0.01.
  }

  dok_translate(V(0,0,0)).
}

FUNCTION dok_sideswipe_port {
  PARAMETER targetPort, dockingPort, distance, speed.

  dockingPort:CONTROLFROM().

  // Get a direction perpendicular to the docking port
  LOCK sideDirection TO targetPort:SHIP:FACING:STARVECTOR.
  IF abs(sideDirection * targetPort:PORTFACING:VECTOR) = 1 {
    LOCK sideDirection TO targetPort:SHIP:FACING:TOPVECTOR.
  }

  LOCK distanceOffset TO sideDirection * distance.
  // Flip the offset if we're on the other side of the ship
  IF (targetPort:NODEPOSITION - dockingPort:NODEPOSITION + distanceOffset):MAG <
     (targetPort:NODEPOSITION - dockingPort:NODEPOSITION - distanceOffset):MAG {
    LOCK distanceOffset TO (-sideDirection) * distance.
  }

  LOCK approachVector TO targetPort:NODEPOSITION - dockingPort:NODEPOSITION + distanceOffset.
  LOCK relativeVelocity TO SHIP:VELOCITY:ORBIT - targetPort:SHIP:VELOCITY:ORBIT.
  LOCK STEERING TO -1 * targetPort:PORTFACING:VECTOR.

  UNTIL FALSE {
    dok_translate((approachVector:normalized * speed) - relativeVelocity).
    IF approachVector:MAG < 0.1 BREAK.
    WAIT 0.01.
  }

  dok_translate(V(0,0,0)).
}

FUNCTION dok_kill_relative_velocity {
  PARAMETER targetPort.

  LOCK relativeVelocity TO SHIP:VELOCITY:ORBIT - targetPort:SHIP:VELOCITY:ORBIT.
  UNTIL relativeVelocity:MAG < 0.1 {
    dok_translate(-relativeVelocity).
  }
  dok_translate(V(0,0,0)).
}

FUNCTION dok_dock {
  PARAMETER dockingPortTag, targetName, targetPortTag.
  SET dockingPort TO dok_get_port(dockingPortTag).
  SET targetVessel TO VESSEL(targetName).
  dockingPort:controlfrom.

  RCS ON.
  dok_ensure_range(targetVessel, dockingPort, 100, 1).

  SET targetPort TO dok_get_port(targetPortTag).
  dok_kill_relative_velocity(targetPort).
  dok_sideswipe_port(targetPort, dockingPort, 100, 1).
  dok_approach_port(targetPort, dockingPort, 100, 1).
  dok_approach_port(targetPort, dockingPort, 50, 1).
  dok_approach_port(targetPort, dockingPort, 20, 1).
  dok_approach_port(targetPort, dockingPort, 10, 0.5).
  dok_approach_port(targetPort, dockingPort, 0, 0.5).
  RCS OFF.
}
