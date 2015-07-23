// Rescuer Rendezvous Functions v1.0.0
// Kevin Gisi
// https://youtube.com/gisikw

// Display a message
FUNCTION NOTIFY {
  PARAMETER message.
  HUDTEXT("kOS: " + message, 5, 2, 50, WHITE, false).
}

// Loop until our distance from the target is increasing
FUNCTION AWAIT_CLOSEST_APPROACH {
  UNTIL FALSE {
    SET lastDistance TO TARGET:DISTANCE.
    WAIT 1.
    IF TARGET:DISTANCE > lastDistance {
      BREAK.
    }
  }
}

// Throttle against our relative velocity vector until we're increasing it
FUNCTION CANCEL_RELATIVE_VELOCITY {
  LOCK STEERING TO TARGET:VELOCITY:ORBIT - SHIP:VELOCITY:ORBIT.
  WAIT 5.

  LOCK THROTTLE TO 0.5.
  UNTIL FALSE {
    SET lastDiff TO (TARGET:VELOCITY:ORBIT - SHIP:VELOCITY:ORBIT):MAG.
    WAIT 1.
    IF (TARGET:VELOCITY:ORBIT - SHIP:VELOCITY:ORBIT):MAG > lastDiff {
      LOCK THROTTLE TO 0. BREAK.
    }
  }
}

// Throttle for five seconds toward the target
FUNCTION APPROACH {
  LOCK STEERING TO TARGET:POSITION.
  WAIT 5. LOCK THROTTLE TO 0.1. WAIT 5.
  LOCK THROTTLE TO 0.
}

// Throttle prograde or retrograde to change our orbital period
FUNCTION CHANGE_PERIOD {
  PARAMETER newPeriod.

  SET currentPeriod TO SHIP:OBT:PERIOD.
  SET boost         TO newPeriod > currentPeriod.

  IF boost {
    LOCK STEERING TO PROGRADE.
  } ELSE {
    LOCK STEERING TO RETROGRADE.
  }

  WAIT 5.
  LOCK THROTTLE TO 0.5.

  IF boost {
    WAIT UNTIL SHIP:OBT:PERIOD > newPeriod.
  } ELSE {
    WAIT UNTIL SHIP:OBT:PERIOD < newPeriod.
  }

  LOCK THROTTLE TO 0.
}
