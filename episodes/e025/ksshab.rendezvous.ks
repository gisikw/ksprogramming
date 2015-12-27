// KSS Hab Rendezvous Script v1.0.0
// Kevin Gisi
// http://youtube.com/gisikw

IF HAS_FILE("maneuver.ks", 1) DELETE maneuver.ks.
IF HAS_FILE("ascent.ks", 1)   DELETE ascent.ks.

DOWNLOAD("rendezvous.ks"). RUN rendezvous.ks.
DOWNLOAD("docking.ks").    RUN docking.ks.

SET KSSCore TO VESSEL("KSSCore").

NOTIFY("Awaiting flyby").
WAIT UNTIL KSSCore:DISTANCE < 15000.

UNTIL KSSCore:DISTANCE < 500 {
  NOTIFY("Killing relative velocity").
  RDV_CANCEL(KSSCore).
  NOTIFY("Making approach with fuel").
  RDV_APPROACH(KSSCore, 30).
  NOTIFY("Awaiting nearest approach").
  RDV_AWAIT_NEAREST(KSSCore, 500).
}
RDV_CANCEL(KSSCore).

NOTIFY("Initiating docking procedure").
dok_dock("HabPort", "KSSCore", "KSSSidePort").
