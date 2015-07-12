PRINT "Returning to Kerbin (maybe?)".

SET direction TO PROGRADE.
LOCK STEERING TO direction.
WAIT 10.
LOCK THROTTLE TO 1.

UNTIL APOAPSIS < 0 {
  PRINT APOAPSIS.
  WAIT 0.001.
}

LOCK THROTTLE TO 0.

//SET prevThrust TO MAXTHRUST.
//WAIT UNTIL MAXTHRUST < (prevThrust - 10).
//WAIT 2.
//PRINT "Staging. No more control. Good luck!".
//STAGE.

//WAIT UNTIL SHIP:OBT:BODY:NAME = "Kerbin".
//PRINT "Headed toward kerbin again. Pointing retrograde.".
//
//DELETE startup.ks.
//TOGGLE BRAKES. // DISABLE DISH
//TOGGLE GEAR. // Disable long-range omni, enable short-range omni
//LOCK STEERING TO RETROGRADE.
