log "" to docking.ks. delete docking.ks.
log "" to rendezvous.ks. delete rendezvous.ks.

download("custom_docking.ks"). run custom_docking.ks.
set target_port to dok_get_port("KSSDepotAttach").
set control_port to dok_get_port("KSSDepotBottom").
dok_approach_port(target_port, control_port, 20, 1).
dok_approach_port(target_port, control_port, 0, 1).
