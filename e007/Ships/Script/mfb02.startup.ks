// Startup script for Munar Probe 2

IF SHIP:ELECTRICCHARGE < 200 {
  TOGGLE BRAKES. // Disable dish
}

IF SHIP:ELECTRICCHARGE > 800 {
  SET p TO SHIP:PARTSNAMED("mediumDishAntenna")[0].
  SET m to p:GETMODULE("ModuleRTAntenna").
  m:SETFIELD("target", "Kerbin").
  TOGGLE RCS.    // Enable dish
}

WAIT 10.
REBOOT.
