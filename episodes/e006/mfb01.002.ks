PRINT "Trying to go to the Mun!".

// This could be done better
FUNCTION MUNAR_ANGLE {
  SET munLng TO BODY("Mun"):LONGITUDE.
  SET shipLng TO SHIP:LONGITUDE.

  IF munLng < 0  { SET munLng TO munLng + 360.   }
  IF shipLng < 0 { SET shipLng TO shipLng + 360. }

  RETURN MOD(BODY("Mun"):LONGITUDE - SHIP:LONGITUDE + 720, 360).
}

FUNCTION ISH {
  PARAMETER a.
  PARAMETER b.
  PARAMETER ishyiness.

  RETURN a - ishyiness < b AND a + ishyiness > b.
}

// Wait for window
WAIT UNTIL ISH(MUNAR_ANGLE(), 135, 0.5).

// Munar Transfer
SET forward TO PROGRADE.
LOCK STEERING TO forward.
WAIT 10.
LOCK THROTTLE TO 1.
WAIT UNTIL APOAPSIS > BODY("Mun"):APOAPSIS.
LOCK THROTTLE TO 0.
PRINT "We choose to go to the Mun".

// Science gettings
WAIT UNTIL SHIP:OBT:BODY:NAME <> "Kerbin".
PRINT "Entered Mun's sphere of influence.".
WAIT 10.
TOGGLE LIGHTS. // Do all the science!
