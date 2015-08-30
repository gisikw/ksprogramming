// MinSat1 Lowpass Script
// Kevin Gisi
// http://youtube.com/gisikw

NOTIFY("Adjusting periapsis for low Minmus science").

LOCK STEERING TO RETROGRADE.
WAIT 10.
LOCK THROTTLE TO 0.01.
WAIT UNTIL PERIAPSIS < 25000.
LOCK THROTTLE TO 0.
NOTIFY("Low periapsis achieved").

WAIT 5.
NOTIFY("Aligning craft for maximum sunlight").
LOCK STEERING TO HEADING(0,0).
WAIT 30.
