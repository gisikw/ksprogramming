log "" to docking.ks. delete docking.ks.
download("custom_docking.ks"). run custom_docking.ks.

set target_port to dok_get_port("KSSDepotBottom").
set control_port to dok_get_port("DrivePort").
dok_approach_port(target_port, control_port, 100, 1).
dok_approach_port(target_port, control_port, 50, 1).
dok_approach_port(target_port, control_port, 20, 1).
dok_approach_port(target_port, control_port, 10, 1).
dok_approach_port(target_port, control_port, 0, 1).
