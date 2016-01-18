log "" to custom_docking.ks.  delete custom_docking.ks.
log "" to rendezvous.ks.      delete rendezvous.ks.
log "" to maneuver.ks.        delete maneuver.ks.

download("maneuver.ks"). run maneuver.ks.

set kss to vessel("KSS").
mnv_exec_node(true).  wait 1.
remove nextnode.      wait 1.
mnv_exec_node(true).  wait 1.
remove nextnode.      wait 1.

delete maneuver.ks.

download("docking.ks"). run docking.ks.
dok_dock("KSSDepotTop", "KSS", "KSSDepotAttach").
