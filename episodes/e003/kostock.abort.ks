// kOStok Abort v1.0.0
// Kevin Gisi
// http://youtube.com/gisikw

NOTIFY("Abort program initiated").

IF PERIAPSIS > 60000 {
  NOTIFY("Orbit detected. Deorbiting").

  LOCK STEERING TO RETROGRADE.
  WAIT 20.
  LOCK THROTTLE TO 1.

  WAIT UNTIL PERIAPSIS < 35000 OR SHIP:LIQUIDFUEL < 0.1 OR SHIP:ELECTRICCHARGE < 5.
}

NOTIFY("Orbital decay achieved").
LOCK THROTTLE TO 0.
SET SHIP:CONTROL:PILOTMAINTHROTTLE TO 0.

WAIT 5. NOTIFY("Detaching").
UNTIL FALSE {
  STAGE.
}
