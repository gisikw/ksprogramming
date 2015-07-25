// Rescuer Rendezvous 2 v1.0.0
// Kevin Gisi
// http://youtube.com/gisikw

DOWNLOAD("orbit.ks").
DOWNLOAD("rescuer.functions.ks").
RUN orbit.ks.
RUN rescuer.functions.ks.

SET victim TO "Lendos' Debris".
SET TARGET TO ORBITABLE(victim).

NOTIFY("Beginning rendezvous procedure").

// Start our rendezvous adjustment at periapsis
WAIT UNTIL ETA:PERIAPSIS < 10.
SET targetAngle     TO TARGET_ANGLE(victim).
SET desiredPeriod   TO TARGET:OBT:PERIOD * (1 + ((360 - targetAngle) / 360 / 3)).

// Boost our orbit, and circle around thrice
CHANGE_PERIOD(desiredPeriod).
SET startTime TO TIME:SECONDS.
WAIT UNTIL TIME:SECONDS > startTime + (desiredPeriod * 2.5).
WAIT UNTIL ETA:PERIAPSIS < 10.

// Bring us in closer by steps
UNTIL TARGET:DISTANCE < 1000 {
  AWAIT_CLOSEST_APPROACH().
  CANCEL_RELATIVE_VELOCITY().
  APPROACH().
}

// Kill remaining relative velocity
CANCEL_RELATIVE_VELOCITY().
NOTIFY("Rendezvous complete!").
