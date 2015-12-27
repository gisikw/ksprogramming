// Rendezvous Library v1.0.0
// Kevin Gisi
// http://youtube.com/gisikw

FUNCTION RDV_STEER {
  PARAMETER vector.

  LOCK STEERING TO vector.
  WAIT UNTIL VANG(SHIP:FACING:FOREVECTOR, vector) < 2.
}

FUNCTION RDV_APPROACH {
  PARAMETER craft, speed.

  LOCK relativeVelocity TO craft:VELOCITY:ORBIT - SHIP:VELOCITY:ORBIT.
  RDV_STEER(craft:POSITION). LOCK STEERING TO craft:POSITION.

  LOCK maxAccel TO SHIP:MAXTHRUST / SHIP:MASS.
  LOCK THROTTLE TO MIN(1, ABS(speed - relativeVelocity:MAG) / maxAccel).

  WAIT UNTIL relativeVelocity:MAG > speed - 0.1.
  LOCK THROTTLE TO 0.
  LOCK STEERING TO relativeVelocity.
}

FUNCTION RDV_CANCEL {
  PARAMETER craft.

  LOCK relativeVelocity TO craft:VELOCITY:ORBIT - SHIP:VELOCITY:ORBIT.
  RDV_STEER(relativeVelocity). LOCK STEERING TO relativeVelocity.

  LOCK maxAccel TO SHIP:MAXTHRUST / SHIP:MASS.
  LOCK THROTTLE TO MIN(1, relativeVelocity:MAG / maxAccel).

  WAIT UNTIL relativeVelocity:MAG < 0.1.
  LOCK THROTTLE TO 0.
}

FUNCTION RDV_AWAIT_NEAREST {
  PARAMETER craft, minDistance.

  UNTIL 0 {
    SET lastDistance TO craft:DISTANCE.
    WAIT 0.5.
    IF craft:distance > lastDistance OR craft:distance < minDistance { BREAK. }
  }
}
