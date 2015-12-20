// kOStok Boot v1.0.0
// Kevin Gisi
// http://youtube.com/gisikw

FUNCTION NOTIFY {
  PARAMETER message.
  HUDTEXT("kOS: " + message, 5, 2, 50, WHITE, false).
}

IF ALT:RADAR < 10 {
  WAIT 10.
  COPY kostock.launch.ks FROM 0.
  COPY kostock.abort.ks FROM 0.
  RUN kostock.launch.ks.
} ELSE {
  RUN kostock.abort.ks.
}
