// Test Script

// Ship's delta v
FUNCTION TLM_DELTAV {
  LIST ENGINES IN shipEngines.
  SET dryMass TO SHIP:MASS - ((SHIP:LIQUIDFUEL + SHIP:OXIDIZER) * 0.005).
  RETURN shipEngines[0]:ISP * 9.81 * LN(SHIP:MASS / dryMass).
}

// Time to complete a maneuver
FUNCTION MNV_TIME {
  PARAMETER deltaV.

  SET maxAccel TO SHIP:MAXTHRUST / SHIP:MASS.
  RETURN deltaV / maxAccel.
}

// Delta v requirements for Hohmann Transfer
FUNCTION MNV_HOHMANN_DV {
  PARAMETER desiredAltitude.

  SET u  TO SHIP:OBT:BODY:MU.
  SET r1 TO SHIP:OBT:SEMIMAJORAXIS.
  SET r2 TO desiredAltitude + SHIP:OBT:BODY:RADIUS.

  // v1
  SET v1 TO SQRT(u / r1) * (SQRT((2 * r2) / (r1 + r2)) - 1).

  // v2
  SET v2 TO SQRT(u / r2) * (1 - SQRT((2 * r1) / (r1 + r2))).

  RETURN LIST(v1, v2).
}

PRINT "Testing Functions".
PRINT "Ship's DeltaV: " + TLM_DELTAV().
PRINT "Time for 100m/s maneuver: " + MNV_TIME(100).
PRINT "Transfer DeltaV to 60km: " + MNV_HOHMANN_DV(60000).

WAIT 500.
