// MinmusRescueI Autopilot v1.0.0
// Kevin Gisi
// http://youtube.com/gisikw

LOG "SET startTime TO TIME:SECONDS."                  TO startup.ks.
LOG ""                                                TO startup.ks.
LOG "UNTIL RCS {"                                     TO startup.ks.
LOG "  IF TIME:SECONDS - startTime > 60 { REBOOT. }"  TO startup.ks.
LOG "  WAIT 1."                                       TO startup.ks.
LOG "}"                                               TO startup.ks.
LOG ""                                                TO startup.ks.
LOG "WAIT UNTIL ADDONS:RT:HASCONNECTION(SHIP)."       TO startup.ks.
LOG "RUN maneuver.ks."                                TO startup.ks.
LOG "MNV_EXEC_NODE()."                                TO startup.ks.
LOG "RCS OFF."                                        TO startup.ks.
LOG "REBOOT."                                         TO startup.ks.
