log "" to rendezvous.ks. delete rendezvous.ks.
log "" to custom_docking.ks. delete custom_docking.ks.
download("rendezvous.ks"). run rendezvous.ks.

set kss to vessel("KSS").
rdv_cancel(kss).
rdv_approach(kss, 20).
rdv_await_nearest(kss, 500).
rdv_cancel(kss).

delete rendezvous.ks.
download("custom_docking.ks"). run custom_docking.ks.

set target_port to dok_get_port("ServicePort").
set control_port to dok_get_port("TugboatSmall").
dok_approach_port(target_port, control_port, 200, 5).
dok_approach_port(target_port, control_port, 100, 1).
dok_approach_port(target_port, control_port, 50, 1).
dok_approach_port(target_port, control_port, 20, 1).
dok_approach_port(target_port, control_port, 10, 1).
dok_approach_port(target_port, control_port, 0, 1).
