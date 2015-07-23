// Rescuer Rendezvous 1 v1.0.0
// Kevin Gisi
// http://youtube.com/gisikw

FUNCTION NOTIFY {
  PARAMETER message.
  HUDTEXT("kOS: " + message, 5, 2, 50, WHITE, false).
}

DOWNLOAD("orbit.ks").
DOWNLOAD("rescuer.functions.ks").
RUN orbit.ks.
RUN rescuer.functions.ks.

SET victim TO "Sigkin's Hulk".
SET TARGET TO ORBITABLE(victim).

NOTIFY("Beginning rendezvous procedure").

// Start our rendezvous adjustment at periapsis
WAIT UNTIL ETA:PERIAPSIS < 10.
SET targetAngle     TO TARGET_ANGLE(victim).
SET desiredPeriod   TO TARGET:OBT:PERIOD * (1 + ((360 - targetAngle) / 360)).

// Boost our orbit, and circle around
CHANGE_PERIOD(desiredPeriod).
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
