log "" to rendezvous.ks. delete rendezvous.ks.
log "" to maneuver.ks.   delete maneuver.ks.
log "" to docking.ks.    delete docking.ks.

download("maneuver.ks").   RUN maneuver.ks.
SET kss_depot TO vessel("KSSDepot").
mnv_exec_node(true).  wait 1.
remove nextnode.      wait 1.
mnv_exec_node(true).  wait 1.
remove nextnode.      wait 1.

delete maneuver.ks.
download("rendezvous.ks"). RUN rendezvous.ks.

until kss_depot:distance < 500 {
  rdv_cancel(kss_depot).
  rdv_approach(kss_depot, 30).
  rdv_await_nearest(kss_depot, 500).
}
rdv_cancel(kss_depot).

delete rendezvous.ks.
download("custom_docking.ks"). RUN custom_docking.ks.
dok_dock("DrivePort", "KSSDepot").
