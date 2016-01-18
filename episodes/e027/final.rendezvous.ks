log "" to custom_docking.ks. delete custom_docking.ks.
log "" to rendezvous.ks. delete rendezvous.ks.
download("maneuver.ks"). run maneuver.ks.

mnv_exec_node(true).  wait 1.
remove nextnode.      wait 1.
mnv_exec_node(true).  wait 1.
remove nextnode.      wait 1.
