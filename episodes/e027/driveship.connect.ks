run rendezvous.ks.

FUNCTION RDV_CANCEL {
  PARAMETER craft.

  LOCK relativeVelocity TO craft:VELOCITY:ORBIT - SHIP:VELOCITY:ORBIT.
  RDV_STEER(relativeVelocity). LOCK STEERING TO relativeVelocity.

  LOCK maxAccel TO SHIP:MAXTHRUST / SHIP:MASS.
  LOCK THROTTLE TO MIN(1, relativeVelocity:MAG / maxAccel).

  WAIT UNTIL relativeVelocity:MAG < 0.5.
  LOCK THROTTLE TO 0.
}

rcs on.
set kss_depot to vessel("KSSDepot").
until kss_depot:distance < 250 {
  rdv_cancel(kss_depot).
  rdv_approach(kss_depot, 10).
  rdv_await_nearest(kss_depot, 250).
}
rdv_cancel(kss_depot).

delete rendezvous.ks.
download("custom_docking.ks"). run custom_docking.ks.
set target_port to dok_get_port("KSSDepotBottom").
set control_port to dok_get_port("DrivePort").
dok_approach_port(target_port, control_port, 100, 1).
dok_approach_port(target_port, control_port, 50, 1).
dok_approach_port(target_port, control_port, 20, 1).
dok_approach_port(target_port, control_port, 10, 1).
dok_approach_port(target_port, control_port, 0, 1).
