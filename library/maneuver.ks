// Maneuver Library v1.0.0
// Kevin Gisi
// http://youtube.com/gisikw

SET burnoutCheck TO "reset".
FUNCTION MNV_BURNOUT {
  PARAMETER autoStage.

  IF burnoutCheck = "reset" {
    SET burnoutCheck TO MAXTHRUST.
    RETURN FALSE.
  }

  IF burnoutCheck - MAXTHRUST > 10 {
    IF autoStage {
      SET currentThrottle TO THROTTLE.
      LOCK THROTTLE TO 0.
      WAIT 1. STAGE. WAIT 1.
      LOCK THROTTLE TO currentThrottle.
    }
    SET burnoutCheck TO "reset".
    RETURN TRUE.
  }

  RETURN FALSE.
}

// Time to complete a maneuver
function mnv_time {
  parameter dv.
  set ens to list().
  ens:clear.
  set ens_thrust to 0.
  set ens_isp to 0.
  list engines in myengines.

  for en in myengines {
    if en:ignition = true and en:flameout = false {
      ens:add(en).
    }
  }

  for en in ens {
    set ens_thrust to ens_thrust + en:availablethrust.
    set ens_isp to ens_isp + en:isp.
  }

  if ens_thrust = 0 or ens_isp = 0 {
    notify("No engines available!").
    return 0.
  }
  else {
    local f is ens_thrust * 1000.  // engine thrust (kg * m/s²)
    local m is ship:mass * 1000.        // starting mass (kg)
    local e is constant():e.            // base of natural log
    local p is ens_isp/ens:length.               // engine isp (s) support to average different isp values
    local g is ship:orbit:body:mu/ship:obt:body:radius^2.    // gravitational acceleration constant (m/s²)
    return g * m * p * (1 - e^(-dv/(g*p))) / f.
  }
}

// Delta v requirements for Hohmann Transfer
FUNCTION MNV_HOHMANN_DV {
  PARAMETER desiredAltitude.

  SET u  TO SHIP:OBT:BODY:MU.
  SET r1 TO SHIP:OBT:SEMIMAJORAXIS.
  SET r2 TO desiredAltitude + SHIP:OBT:BODY:RADIUS.

  // v1
  SET v1 TO SQRT(u / r1) * (SQRT((2 * r2) / (r1 + r2)) - 1).

  // v2
  SET v2 TO SQRT(u / r2) * (1 - SQRT((2 * r1) / (r1 + r2))).

  RETURN LIST(v1, v2).
}

// Execute the next node
FUNCTION MNV_EXEC_NODE {
  PARAMETER autoWarp.

  LOCAL n IS NEXTNODE.
  LOCAL v IS n:BURNVECTOR.

  LOCAL startTime IS TIME:SECONDS + n:ETA - MNV_TIME(v:MAG)/2.
  LOCK STEERING TO n:BURNVECTOR.

  IF autoWarp { WARPTO(startTime - 30). }

  WAIT UNTIL TIME:SECONDS >= startTime.
  LOCK THROTTLE TO MIN(MNV_TIME(n:BURNVECTOR:MAG), 1).
  WAIT UNTIL VDOT(n:BURNVECTOR, v) < 0.
  LOCK THROTTLE TO 0.
  UNLOCK STEERING.
}
