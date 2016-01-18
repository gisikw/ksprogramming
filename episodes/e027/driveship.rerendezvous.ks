log "" to docking.ks. delete docking.ks.

download("rendezvous.ks"). run rendezvous.ks.

FUNCTION RDV_CANCEL {
  PARAMETER craft.

  LOCK relativeVelocity TO craft:VELOCITY:ORBIT - SHIP:VELOCITY:ORBIT.
  RDV_STEER(relativeVelocity). LOCK STEERING TO relativeVelocity.

  LOCK maxAccel TO SHIP:MAXTHRUST / SHIP:MASS.
  LOCK THROTTLE TO MIN(1, relativeVelocity:MAG / maxAccel).

  WAIT UNTIL relativeVelocity:MAG < 0.5.
  LOCK THROTTLE TO 0.
}

set kss_depot to vessel("KSSDepot").

notify("Returning to KSSDepot").
until kss_depot:distance < 500 {
  rdv_cancel(kss_depot).
  rdv_approach(kss_depot, 50).
  rdv_await_nearest(kss_depot, 500).
}
rdv_cancel(kss_depot).
notify("Made nearest approach").
