// KSS Hab Rotation Script v1.0.0
// Kevin Gisi
// http://youtube.com/gisikw

RUN docking.ks.
NOTIFY("Beginning redocking maneuver").

SET targetPort TO dok_get_port("BottomPort").
SET dockingPort TO dok_get_port("HabPort").

// Custom for rotation
FUNCTION custom_approach_port {
  PARAMETER targetPort, dockingPort, distance, speed.

  dockingPort:CONTROLFROM().

  LOCK distanceOffset TO targetPort:PORTFACING:VECTOR * distance.
  LOCK approachVector TO targetPort:NODEPOSITION - dockingPort:NODEPOSITION + distanceOffset.
  LOCK relativeVelocity TO SHIP:VELOCITY:ORBIT - targetPort:SHIP:VELOCITY:ORBIT.
  LOCK STEERING TO LOOKDIRUP(-targetPort:PORTFACING:VECTOR, targetPort:PORTFACING:STARVECTOR).

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

NOTIFY("Docking..").
RCS ON.
dok_ensure_range(targetPort:SHIP, dockingPort, 50, 2).
custom_approach_port(targetPort, dockingPort, 50, 2).
custom_approach_port(targetPort, dockingPort, 10, 1).
custom_approach_port(targetPort, dockingPort, 5, 0.5).
custom_approach_port(targetPort, dockingPort, 0, 0.5).
RCS OFF.
NOTIFY("Done").
