// KSS Hab Shuffle Script v1.0.0
// Kevin Gisi
// http://youtube.com/gisikw

RUN docking.ks.
NOTIFY("Beginning redocking maneuver").

SET targetPort TO dok_get_port("BottomPort").
SET dockingPort TO dok_get_port("HabPort").

NOTIFY("Docking..").
RCS ON.
dok_ensure_range(targetPort:SHIP, dockingPort, 50, 2).
dok_approach_port(targetPort, dockingPort, 50, 2).
dok_approach_port(targetPort, dockingPort, 10, 1).
dok_approach_port(targetPort, dockingPort, 5, 0.5).
dok_approach_port(targetPort, dockingPort, 0, 0.5).
RCS OFF.
NOTIFY("Done").
