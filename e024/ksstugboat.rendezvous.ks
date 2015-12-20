// KSS Tugboat Rendezvous Script v1.0.0
// Kevin Gisi
// http://youtube.com/gisikw

NOTIFY("Beginning Rendezvous Procedure").
IF HAS_FILE("docking.ks", 1) DELETE docking.ks.
IF HAS_FILE("ascent.ks", 1)  DELETE ascent.ks.
DOWNLOAD("docking.ks").
RUN maneuver.ks.
RUN docking.ks.

NOTIFY("Initializing Rendezvous Maneuvers").
LOCK STEERING TO HEADING(0,0). WAIT 5.
MNV_EXEC_NODE(TRUE). REMOVE NEXTNODE.
WAIT 1.
LOCK STEERING TO HEADING(0,0). WAIT 5.
MNV_EXEC_NODE(TRUE). REMOVE NEXTNODE.

NOTIFY("Making initial approach with RCS").
RCS ON.
dok_ensure_range(VESSEL("KSSCore"), SHIP:DOCKINGPORTS[0], 200, 10).
dok_kill_relative_velocity(VESSEL("KSSCore"):DOCKINGPORTS[0]).

NOTIFY("Waiting for manual undock for final docking").
WAIT UNTIL SHIP:DOCKINGPORTS:LENGTH = 2.
NOTIFY("Beginning docking procedure").
dok_dock("TugboatPort", "KSSCore", "TugboatTarget").
